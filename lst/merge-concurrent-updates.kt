override fun tryMergeConcurrentUpdates(
    database: SqlProjectDatabaseImpl,
    serverTransaction: List<XlogRecord>,
    clientTransaction: List<XlogRecord>
): Boolean {
    val serverConnection = database.createConnection()
    val clientConnection = database.createConnection()
    serverConnection.transactionIsolation = Connection.TRANSACTION_REPEATABLE_READ
    clientConnection.transactionIsolation = Connection.TRANSACTION_REPEATABLE_READ
    val serverDsl = dsl(serverConnection)
    val clientDsl = dsl(clientConnection)
    serverDsl.startTransaction().execute()
    clientDsl.startTransaction().execute()
    try {
        serverTransaction.forEach {
            it.colloboqueOperations.forEach {
                LOG.debug("... applying operation={}", it)
                serverDsl.execute(generateSqlStatement(serverDsl, it))
            }
        }
        clientTransaction.forEach {
            it.colloboqueOperations.forEach {
                LOG.debug("... applying operation={}", it)
                // Hangs here. 
                // When `serverDsl.commit().execute()` is moved
                // before the `clientTransaction.forEach { ... }`
                // block, the whole function executes successfully 
                // and returns true even if there 
                // should have been a conflict. 
                // Transaction isolation level setting 
                // doesn't affect this behaviour.
                clientDsl.execute(generateSqlStatement(clientDsl, it))
            }
        }
        LOG.debug("... committing server's transaction")
        if (serverDsl.commit().execute() != 0) return false
        LOG.debug("... committing client's transaction")
        return clientDsl.commit().execute() == 0
    } catch (e: Exception) {
        LOG.info("Failed to execute transactions in parallel! Reason: ${e.localizedMessage}")
    }
    return false
}
