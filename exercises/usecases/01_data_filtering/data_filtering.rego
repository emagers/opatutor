# Exercise - Data Filtering
#
# Overview:
#   A common OPA use-case is producing a *filtered view* of a dataset rather
#   than a single allow/deny decision. The policy iterates a collection and
#   keeps only the elements the caller is permitted to see. A downstream system
#   (a database query layer, API handler, etc.) can use the result to return
#   only authorised data.
#
#   OR logic with partial rules: defining two rules with the same name is how
#   Rego expresses OR. A document belongs to `readable_docs` if rule-body-A is
#   true OR rule-body-B is true — no `||` operator needed.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/filtering-data/
#
# Files in this exercise:
#   data_filtering.rego       ← this file (write the policy)
#   data.json                 ← document catalogue (do NOT edit)
#   data_filtering_test.rego  ← tests (do NOT edit)
#
# data.json structure:
#   {
#     "documents": [
#       { "id": string, "owner": string, "classification": "public"|"private" }
#     ]
#   }
#
# Input structure:
#   { "user": string }   -- the username of the requesting user
#
# Example inputs / expected results:
#   { "user": "alice" }
#       → readable_docs = {"doc-1", "doc-2", "doc-4"}
#         (doc-1: owned by alice; doc-2, doc-4: public)
#       → summary = 3
#   { "user": "nobody" }
#       → readable_docs = {"doc-2", "doc-4"}  (only public docs)
#       → summary = 2
#
# Tasks:
#   1. Write the first `readable_docs` partial set rule that adds a document's
#      `id` when the requesting user (`input.user`) is the document's `owner`.
#      Iterate over `data.documents` and compare `doc.owner`.
#
#   2. Write a second `readable_docs` partial set rule that adds a document's
#      `id` when its `classification` equals "public".
#      (Having two rules with the same name implements OR logic.)
#
#   3. Write the `summary` complete rule that returns the count of documents
#      in `readable_docs` (not the total number of all documents).

package usecases.data_filtering

import rego.v1

# TODO 1: collect IDs of documents owned by the requesting user (input.user)
# readable_docs contains doc.id if {
#     ...
# }

# TODO 2: collect IDs of documents whose classification is "public"
#         (same rule name → OR logic with TODO 1)
# readable_docs contains doc.id if {
#     ...
# }

# TODO 3: return the count of readable_docs for the requesting user
# summary := ...

# --- stubs (tests will fail until you complete the TODOs above) ---
readable_docs contains id if {
	id := data.documents[_].id
	false
}

summary := 0 if { false }
