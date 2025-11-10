# queue.sh
# Simple Queue "module" for Bash

# Guard against multiple inclusions
if [[ -z "${QUEUE_SH_INCLUDED}" ]]; then
QUEUE_SH_INCLUDED=1

# ========================================================
# Create a new queue with the name provided
# @param queueName
# Example usage:
#     queue_new MyNewQueue
# ========================================================
queue_new() {
  local name="$1"
  eval "${name}=()"
}

# Enqueue (push to end)
queue_enqueue() {
  local name="$1"
  local value="$2"
  eval "${name}+=(\"\${value}\")"
}

# Dequeue (remove from front)
queue_dequeue() {
  local name="$1"
  local var="$2"
  local value

  # Retrieve and remove first element
  eval "value=\"\${${name}[0]}\""
  eval "${name}=(\"\${${name}[@]:1}\")"

  # Optionally return via variable name
  if [[ -n "$var" ]]; then
    eval "$var=\"\$value\""
  else
    echo "$value"
  fi
}

# Peek (see front element)
queue_peek_front() {
  local name="$1"
  eval "echo \"\${${name}[0]}\""
}

queue_peek_back() {
  local name="$1"
  local var="$2"
  local length last_index value

  # Get length of the array dynamically
  eval "length=\${#${name}[@]}"

  if (( length == 0 )); then
    return 1  # exit function with error code
  fi

  last_index=$(( length - 1 ))
  eval "value=\"\${${name}[$last_index]}\""

  if [[ -n "$var" ]]; then
    eval "$var=\"\$value\""
  else
    echo "$value"
  fi
}

# Get size
queue_size() {
  local name="$1"
  eval "echo \"\${#${name}[@]}\""
}

# Print queue contents (for debugging)
queue_print() {
  local name="$1"
  eval "echo \"\${${name}[@]}\""
}

queue_find() {
  local name="$1"
  local search_value="$2"

  # Access array dynamically using indirect expansion
  eval "local array=(\"\${${name}[@]}\")"
#   echo "search: ($search_value) "

  for element in "${array[@]}"; do
    # echo "element: ($element)"
    if [[ "$element" == "$search_value" ]]; then
      return 0
    fi
  done

  return 1
}


fi
