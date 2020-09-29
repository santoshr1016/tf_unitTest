package terraform.module

# The policy evaluates if a security group is valid based on the contents of it’s description:
# Resources can be specified under the root module or in child modules

# We want to evaluate against the combined group of these resources

# This example is scoped to the planned changes section of the json representation
# The policy uses the walk keyword to explore the json structure, and uses conditions to
# filter for the specific paths where resources would be found.

deny[msg] {
  desc := resources[r].values.description
  contains(desc, "HTTP")
  msg = sprintf("No security groups should be using HTTP. Resource in violation: %v",[r.address])
}

resources := { r |
  some path, value

  # Walk over the JSON tree and check if the node we are
  # currently on is a module (either root or child) resources
  # value.
  walk(input.planned_values, [path, value])

  # Look for resources in the current value based on path
  rs := module_resources(path, value)

  # Aggregate them into `resources`
  r := rs[_]
}

# Variant to match root_module resources
module_resources(path, value) = rs {

  # Expect something like:
  #
  #     {
  #     	"root_module": {
  #         	"resources": [...],
  #             ...
  #         }
  #         ...
  #     }
  #
  # Where the path is [..., "root_module", "resources"]

  reverse_index(path, 1) == "resources"
  reverse_index(path, 2) == "root_module"
  rs := value
}

# Variant to match child_modules resources
module_resources(path, value) = rs {

  # Expect something like:
  #
  #     {
  #     	...
  #         "child_modules": [
  #         	{
  #             	"resources": [...],
  #                 ...
  #             },
  #             ...
  #         ]
  #         ...
  #     }
  #
  # Where the path is [..., "child_modules", 0, "resources"]
  # Note that there will always be an index int between `child_modules`
  # and `resources`. We know that walk will only visit each one once,
  # so we shouldn't need to keep track of what the index is.

  reverse_index(path, 1) == "resources"
  reverse_index(path, 3) == "child_modules"
  rs := value
}

reverse_index(path, idx) = value {
	value := path[count(path) - idx]
}
