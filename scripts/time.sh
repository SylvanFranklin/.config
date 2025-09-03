#!/bin/bash

CATEGORIES=(
	"MATH"
	"WORKFLOW"
	"VIDEO"
	"PROGRAMMING"
	"DRAWING"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | sk --margin 10% --color="bw")

timew start $selected
