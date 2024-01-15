#include "compute.h"

int multiply(matrix_t *a_matrix, int32_t *b_matrix, int row, int col, int num_rowb, int num_colb) {
  
  int num_rowa = a_matrix->rows;
  int num_cola = a_matrix->cols;
  int shift = (row*num_cola) + col;
  int sum = 0;
  for (int i=0; i<num_rowb; i++) {
    for (int j=0; j<num_colb; j++) {
      sum += a_matrix->data[shift+j+(i*num_cola)] * b_matrix[j+(i*num_colb)];
    }
  }
  return sum;
}

// Computes the convolution of two matrices

int convolve(matrix_t *a_matrix, matrix_t *b_matrix, matrix_t **output_matrix) {
  // TODO: convolve matrix a and matrix b, and store the resulting matrix in
  // output_matrix
  *output_matrix = malloc(sizeof(matrix_t));
  (*output_matrix)->rows = a_matrix->rows - b_matrix->rows + 1;
  (*output_matrix)->cols = a_matrix->cols - b_matrix->cols + 1;
  (*output_matrix)->data = (int*) malloc(sizeof(int) * (*output_matrix)->rows * (*output_matrix)->cols);
  int *b_matrix_flipped = (int*) malloc(sizeof(int) * b_matrix->rows * b_matrix->cols);
  for (int i=0; i<b_matrix->rows; i++) {
    for (int j=0; j<b_matrix->cols; j++) {
      b_matrix_flipped[(i*(b_matrix->cols))+j] = b_matrix->data[(b_matrix->rows-i)*(b_matrix->cols)-j-1];
    }
  }
  int rows = (*output_matrix)->rows;
  int cols = (*output_matrix)->cols;
  for (int i=0; i<rows; i++) {
    for (int j=0; j<cols; j++) {
      (*output_matrix)->data[(i*cols)+j] = multiply(a_matrix, b_matrix_flipped, i, j, b_matrix->rows, b_matrix->cols);
    }
  }
  free(b_matrix_flipped);

  return 0;
}

// Executes a task
int execute_task(task_t *task) {
  matrix_t *a_matrix, *b_matrix, *output_matrix;

  char *a_matrix_path = get_a_matrix_path(task);
  if (read_matrix(a_matrix_path, &a_matrix)) {
    printf("Error reading matrix from %s\n", a_matrix_path);
    return -1;
  }
  free(a_matrix_path);

  char *b_matrix_path = get_b_matrix_path(task);
  if (read_matrix(b_matrix_path, &b_matrix)) {
    printf("Error reading matrix from %s\n", b_matrix_path);
    return -1;
  }
  free(b_matrix_path);

  if (convolve(a_matrix, b_matrix, &output_matrix)) {
    printf("convolve returned a non-zero integer\n");
    return -1;
  }

  char *output_matrix_path = get_output_matrix_path(task);
  if (write_matrix(output_matrix_path, output_matrix)) {
    printf("Error writing matrix to %s\n", output_matrix_path);
    return -1;
  }
  free(output_matrix_path);

  free(a_matrix->data);
  free(b_matrix->data);
  free(output_matrix->data);
  free(a_matrix);
  free(b_matrix);
  free(output_matrix);
  return 0;
}
