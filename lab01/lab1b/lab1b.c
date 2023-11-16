#define STDOUT_FD 1
/* Buffer para leitura de dados */
char input_buffer[6];


void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1


void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

int read(int __fd, const void *__buf, int __n)
{
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall read code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)                   // Output list
    : "r"(__fd), "r"(__buf), "r"(__n) // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}


void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}



int somar(int a, int b){
    int soma = a + b;
    return soma;
}

int subtrair(int a, int b){
    int subtracao = a - b;
    return subtracao;
}

int multiplicar(int a, int b){
    int multiplicacao = a*b;
    return multiplicacao;
}

int conversorChar_Int(char a){
    int convertido = a - '0'; 
    return convertido;
}

char conversorInt_char(int a){
    char convertido = a + '0';
    return convertido;
}


int main()
{

  int n = read(STDIN_FD, (void*) input_buffer, 6);
  input_buffer[n]  = '\n';


  int s1 = conversorChar_Int(input_buffer[0]);
  int s2 = conversorChar_Int(input_buffer[4]);
  char op = input_buffer[2];

  int resultI;
  char result;

  if (op == '+'){
    resultI = somar(s1,s2);
  }

  if (op == '-'){
    resultI = subtrair(s1,s2);
  }

  if (op == '*'){
    resultI = multiplicar(s1,s2);
  }

  result = conversorInt_char(resultI);

  char resultado[2];

  resultado[0] = result;
  resultado[1] = '\n';

  write(STDOUT_FD,resultado,2);
      
    return 0;
}