predict.regsubsets <- function(model, data) {
    ret <- list()
    nvmax <- model$np - 1
    
    for (x in 1:nvmax) {
        coefs <- coefficients(model, x)[-1]
        matrix_columns <- names(data) %in% names(coefs)
    
        result <- as.vector( as.matrix(data[, matrix_columns]) %*% coefs )
        #print(result)
        
        ret[[x]] <- result
    }
    
    
    
    return (ret)
}
