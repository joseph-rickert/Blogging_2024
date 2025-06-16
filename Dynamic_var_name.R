# Create a variable name string
variable_name <- paste("my_variable_", 1, sep="")  # creates "my_variable_1"
variable_name
# Assign a value to the dynamic variable name
assign(variable_name, 100)

# Check the value
print(my_variable_1)
