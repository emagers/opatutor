# Exercise 08 - Data Filtering
#
# Overview:
#   A common OPA use-case is *partial evaluation* / data filtering: instead of
#   making a single allow/deny decision, the policy produces a set of conditions
#   (or a filtered view of a dataset) that a downstream system (e.g., a database
#   or API layer) can use to retrieve only the data the caller is allowed to see.
#
#   The simplest form is a comprehension that iterates over a collection in
#   `data` or `input` and keeps only the elements that satisfy a policy check.
#
#   This exercise models a document store where each document has an `owner`
#   and a `classification` level. The policy determines which documents a
#   requesting user may read.
#
# Documentation:
#   https://www.openpolicyagent.org/docs/latest/filtering-data/
#
# Files in this exercise:
#   data_filtering.rego       ← this file  (fix the policy)
#   data.json                 ← document catalogue  (do NOT edit)
#   data_filtering_test.rego  ← tests  (do NOT edit)
#
# Task:
#   Two rules need fixing:
#
#   1. `readable_docs` should return the IDs of documents the requesting user
#      may read. A user may read a document when EITHER:
#        a) they are the document owner, OR
#        b) the document classification is "public".
#      The two partial rules below implement (a) and (b), but the ownership
#      check uses the wrong field — it compares `doc.author` instead of
#      `doc.owner`. Fix it.
#
#   2. `summary` should return a count of how many documents the user can read.
#      It currently returns the count of ALL documents regardless of the user.
#      Fix it so it counts only the entries in `readable_docs`.

package usecases.data_filtering

import rego.v1

# Collect IDs of documents owned by the requesting user.
readable_docs contains doc.id if {
	doc := data.documents[_]
	# TODO: fix the field name — ownership is stored in doc.owner, not doc.author
	doc.author == input.user
}

# Collect IDs of public documents (anyone may read these).
readable_docs contains doc.id if {
	doc := data.documents[_]
	doc.classification == "public"
}

# Return a count of readable documents for the requesting user.
summary := count(data.documents)
