import java.lang.Integer.max

const val MAX_REPLICAS = 3

class StateCounter(
    // One of {0, 1, ..., MAX_REPLICAS - 1}
    // The problem of assigning a unique id
    // is not considered in the context of this example
    private val id: Int = 0
) {
    // Initial state
    private val counter = MutableList(MAX_REPLICAS) { 0 }

    // Update operation
    fun increment() {
        counter[id] += 1
    }

    // Query
    fun value() = counter.sum()

    // Merge function
    fun merge(other: StateCounter) {
        for (i in 0 until MAX_REPLICAS) {
            counter[i] = max(counter[i], other.counter[i])
        }
    }
}