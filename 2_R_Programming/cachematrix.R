## Functions for caching inverse of a matrix

## Function 1 - Creates matrix (m) object which can cache it's own inverse (i)
makeCacheMatrix <- function(x = matrix()) {
  i <- NULL                                      # Initiate (empty) inverse
  set <- function(matrix ) {                     # Set the matrix (m) and ensure empty inverse (i)
    m <<- matrix
    i <<- NULL
  }
  get <- function() m                            # Returns matrix (m)
  setInverse <- function(inverse) i <<- inverse  # Sets i to inverse
  getInverse <- function() i                     # Returns inverse (i)
  list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}

## Function 2 - Return cache, and if not, compute inverse of matrix x
cacheSolve <- function(x, ...) {
  inv <- x$getInverse()               # Look for cached i and assign to the matrix (inv) to return
  if(!is.null(inv)) {                 # Return result cached if available
    message("getting cached result")
    return(inv)
  }
  data <- x$get()                     # Get the matrix and assign to data
  inv <- solve(data, ...)             # Calculate the inverse of data and assign to inv to be returned
  x$setInverse(inv)                   # Cache the inverse (returns i) on the matrix
  inv                                 # Return the inverted matrix
}