int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
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

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1


void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;
    
    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int potencia(int a,int b){
  int potencia = 1;
  for(int i = 0; i < b; i++){
    potencia = a*potencia;
  }
  return potencia;
}

int conversorChar_Int(char a){
    int convertido = a - '0'; 
    return convertido;
}

char conversorInt_char(int a){
    char convertido = a + '0';
    return convertido;
}

int conversorCharDec(char str[5]){

  char sinal = str[0];
  int valor = 0;
  int expoente = 3;
  for(int i = 1; i < 5;i++){
    valor += conversorChar_Int(str[i])*potencia(10,expoente);
    expoente--;
  }

  if (sinal == '-'){
    valor = valor*-1;
  }

  return valor;
}

int quebraVetor(char str[], int inicio, int fim){

  char vetor_ret[5];
  int j = 0;
  for(int i = inicio; i < fim+1; i++){
    vetor_ret[j] = str[i];
    j++;
  }

  int valor = conversorCharDec(vetor_ret);
  return valor;
}


int main()
{


  char str[30];
  int n = read(STDIN_FD, str, 30);

  //zera e coloca na posiÃ§Ã£o
  int N1 = quebraVetor(str,0,4);
  int mask1 = 0b00000000000000000000000000000111;

  int N2 = quebraVetor(str,6,10);
  int mask2 = 0b00000000000000000000000011111111;

  int N3 = quebraVetor(str,12,16);
  int mask3 = 0b00000000000000000000000000011111;


  int N4 = quebraVetor(str,18,22);
  int mask4 = 0b00000000000000000000000000011111;


  int N5 = quebraVetor(str,24,28);
  int mask5 = 0b00000000000000000001111111111111;

  int vetor = ((N1 & mask1) | ((N2 & mask2) << 3) | ((N3 & mask3) << 11) | ((N4 & mask4) << 16) | ((N5 & mask5) << 21));

  hex_code(vetor);

  return 0;
}