locals {
    map_example = {
        key1 = {
            subkey1 = "subvalue11"
            subkey2 = "subvalue12"
        }
        key2 = {
            subkey1 = "subvalue21"
            subkey2 = "subvalue22"
        }
        key3 = {
            subkey1 = "subvalue31"
            subkey2 = "subvalue32"
        }
    }

    list_example = flatten([
        for key, value in local.map_example : [
            value
        ]
    ])

    map_keys_as_map = {
        for key, value in local.map_example : key => "key is: ${key}, value is: ${jsonencode(value)}"
    }

    list_keys_as_map = {
        for key, value in local.list_example : key => "key is: ${key}, value is: ${jsonencode(value)}"
    }
}

# Create local files for each list item: file-{index}.json vs. actual element as content
resource "local_file" "file_per_list_item" {
  # for_each doesn't work with lists, therefore the list needs to be transformed in a map with item-index vs. item-value.
  # for_each = local.list_example
  for_each = { for idx, val in local.list_example : idx => val }

  content  = jsonencode(each.value)
  filename = "${path.module}/file-${each.key}.json"
}

output "map_example" {
    value = local.map_example
}

output "list_example" {
    value = local.list_example
}

output "map_keys_as_map" {
    value = local.map_keys_as_map
}

output "list_keys_as_map" {
    value = local.list_keys_as_map
}


