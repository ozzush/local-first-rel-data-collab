use automerge::ReadDoc;
use automerge::transaction::Transactable;

fn main() {
    // Create an automerge document and its replica
    let mut first_doc = automerge::Automerge::new();
    let mut second_doc = first_doc.fork();

    // Set property "key" to "first value" in the original document
    first_doc.transact::<_, _, automerge::AutomergeError>(|doc| {
        Ok(doc.put(automerge::ROOT, "key", "first value").unwrap())
    }).unwrap();
    // Set property "key" to "second value" in the replica
    second_doc.transact::<_, _, automerge::AutomergeError>(|doc| {
        Ok(doc.put(automerge::ROOT, "key", "second value").unwrap())
    }).unwrap();

    // Replicas merge each other's changes
    first_doc.merge(&mut second_doc).unwrap();
    second_doc.merge(&mut first_doc).unwrap();

    // Get the conflict object
    let conflict1: Vec<_> = first_doc
        .get_all(automerge::ROOT, "key").unwrap();
    // Get the resolved conflict value
    let value1 = first_doc.
        get(automerge::ROOT, "key").unwrap().unwrap().0;

    // Get the replica's conflict object
    let conflict2: Vec<_> = second_doc
        .get_all(automerge::ROOT, "key").unwrap();
    // Get the resolved conflict value
    let value2 = second_doc
        .get(automerge::ROOT, "key").unwrap().unwrap().0;

    println!("{:?}", conflict1);
    // [(Scalar(Str("first value")), Id(1, ActorID("aaa"), 0)), (Scalar(Str("second value")), Id(1, ActorID("bbb"), 1))]
    println!("{:?}", conflict2);
    // [(Scalar(Str("first value")), Id(1, ActorID("aaa"), 1)), (Scalar(Str("second value")), Id(1, ActorID("bbb"), 0))]
    println!("{:?}", value1); // Scalar(Str("second value"))
    println!("{:?}", value2); // Scalar(Str("second value"))
}
