#!/bin/zsh

# Get page size in bytes
pageSize=$(vm_stat | awk '/page size of/ {print $8}')

# Function to convert pages to human readable format
function pagesToHumanReadable {
    echo $(bc <<< "scale=2; $1 * $pageSize / 1024 / 1024")MB
}

# Get memory stats
stats=$(vm_stat)

# Extract and convert values
freePages=$(pagesToHumanReadable $(echo "$stats" | grep 'Pages free:' | awk '{print $3}'))
cachedFiles=$(pagesToHumanReadable $(echo "$stats" | grep 'File-backed pages:' | awk '{print $3}'))
compressedMemory=$(pagesToHumanReadable $(echo "$stats" | grep 'Pages occupied by compressor:' | awk '{print $5}'))
swapUsage=$(sysctl vm.swapusage | awk -F'=' '{print $2}' | awk '{print $1}')


# Print results
echo "Available Memory:       $freePages"
echo "Cached Files:           $cachedFiles"
echo "Compressed Memory:      $compressedMemory"
echo "Swap Usage:             $swapUsage"
