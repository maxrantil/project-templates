// ABOUTME: Integration tests for the Rust project

use project_name::add;

#[test]
fn test_add_integration() {
    assert_eq!(add(5, 7), 12);
}
