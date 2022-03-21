package test

import (
	"testing"
)

func TestPermissionBoundaryExample(t *testing.T) {
	testIAMRole(t, "pb")
}
