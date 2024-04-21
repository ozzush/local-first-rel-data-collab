import kotlin.random.Random

typealias OperationId = Long

class OperationCounter {

    // Initial state
    private val increments = mutableSetOf<OperationId>()

    // Update operation
    fun increment() {
        val operationId = incrementAtSource()
        incrementDownstream(operationId)
    }

    // atSource phase of the increment operation
    private fun incrementAtSource(): OperationId {
        return Random.nextLong()
    }

    // downstream phase of the increment operation
    fun incrementDownstream(operationId: OperationId) {
        increments.add(operationId)
    }

    // Query
    fun value() = increments.size
}
