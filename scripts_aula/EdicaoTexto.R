#############################
### Aula Edicao de Texto  ###
#############################
## Prof. Renato A. Ferreira de Lima - LCB/ESALQ/USP

# VETORES DE TEXTO/CARACTERES -------------------------------------
## Quando seus dados não são números...

## Um exemplo de um vetor de caracteres:
(texto <- c("especie A","especie C","especie B","especie B"))

## tipo de objeto e teste lógico ('is.character')
class(texto)
is.character(texto)

## podemos operar vetores de caracteres!
(length(texto))
(rev(texto))
(sort(texto))
(sample(x = texto, size = 2))
intersect(texto, "especie B")
setdiff(texto, "especie B")
sum(texto) # nem sempre...

## gerando vetores de caracters vazios (função 'character')
(vetor_vazio <- character(0))
(vetor_vazio1 <- character(10))

## vetores com classes misturadas
(mistura <- c(1:2, pi, FALSE, letters[1:2]))
class(mistura) # classe 'character' domina!

## podemos forçar números a virarem texto (função 'as.character')
(nums <- 1:4)
class(nums)
(nums_char <- as.character(nums))
class(nums_char)
is.character(nums_char)

## e o contrário, pode? pode, mas...
(as.numeric(nums_char))
(as.numeric(texto))


# MANIPULANDO CARACTERES: FUNÇÕES BÁSICAS -------------------------

## vetor de nomes de frutas
frutas <- c("Banana","Maça","Laranja-Lima","KIWI")

## maiúsculas e minúsculas ('toupper', 'tolower')
toupper(frutas)
tolower(frutas)

## número de caracteres por elemento ('nchar')
length(frutas)
nchar(frutas)

## colando  (funções 'paste' e 'paste0')
paste(frutas, 1:length(frutas))
paste0(frutas, 1:length(frutas))
paste(frutas, 1:length(frutas), sep = "")
paste(frutas, 1:length(frutas), sep = "-")
paste(frutas, collapse = ", ")

## concatenando e imprimindo (função 'cat')
cat("Frutas que gosto:", frutas)
cat(frutas)
cat("Frutas que gosto:", frutas)
cat(frutas, fill = 10) # quebrando strings muito longos

## localizando (funções 'grep' e 'grepl')
grep("ç", frutas)
grepl("ç", frutas)

## localizando e substituindo ('chartr', 'sub', 'gsub')
chartr("ç", "c", frutas) # só faz substituições 1 a 1
chartr("ç", "cA", frutas)
chartr("ça", "cA", frutas) # não era bem isso
chartr("ça", "c", frutas) # não funciona (erro!)

sub("ça", "cA", frutas) # mais flexível
sub("a", "A", frutas) # mais flexível, mas subs. só o 1o
gsub("a", "A", frutas) # substituição global (todas)

## dividindo (função 'strsplit')
strsplit(frutas, split = " ")
strsplit(frutas, split = "a")
strsplit(frutas, split = "-")
strsplit(frutas, split = "")

## cortando (funções 'strtrim', 'substr' e 'substring')
strtrim(frutas, width = 2)

substr(frutas, start = 1, stop = 2)
substr(frutas, start = 1, stop = 1:5)

substring(frutas, first = 1:5)
substring(frutas, first = 1:5, last = 1:5)

## abreviando (função 'abbreviate')
abbreviate(frutas, 5)

# UM EXEMPLO PRÁTICO: Capitalização -------------------------------

## Nosso mesmo vetor de antes
frutas <- c("Banana","Maça","Laranja-Lima","KIWI","fruta do conde")

## Apenas a primeira letra maiúscula?
(primeira <- substr(frutas, start = 1, stop = 1))
(primeira <- toupper(primeira))

(resto <- substring(frutas, first = 2))
(resto <- tolower(resto))

frutas.cap <- paste0(primeira, resto)
cbind(frutas, frutas.cap)



# VISUALIZANDO EXPRESSÕES REGULARES: REGEX ------------------------
## Busca de padrões: liberando o poder da manipulação de texto... 
## Regex também é usado em Java, Ruby, Python, etc.
## http://en.wikipedia.org/wiki/Regular_expression
## veja ?regexp para detalhes no R
## veja também https://www.regextranslator.com/

## instalando o pacote 'stringr' para visualização
if (!requireNamespace("stringr")) install.packages("stringr")

## CLASSES e ÂNCORAS em buscas usando RegEx no R
exemplo <- "(Espécie - A24)"

### qualquer digito/número: [:digit:] (equivale ao \d)
stringr::str_view(exemplo, '[:digit:]')
stringr::str_view(exemplo, '\\d')
stringr::str_view(exemplo, '\\D') # o oposto

### todas as letras: [:alpha:]
stringr::str_view(exemplo, '[:alpha:]')
stringr::str_view(exemplo, '[a-eA-E]') # ou intervalo específico

### qualquer letra minúscula: [:lower:] ou [a-z]
stringr::str_view(exemplo, '[:lower:]')
stringr::str_view(exemplo, '[a-e]') # ou intervalo específico

### qualquer letra maiúscula: [:upper:]
stringr::str_view(exemplo, '[:upper:]')
stringr::str_view(exemplo, '[A-E]') # ou intervalo específico

### qualquer letra ou digito/número: [:alnum:] (equivale ao \w)
stringr::str_view(exemplo, '[:alnum:]')
stringr::str_view(exemplo, '\\w')
stringr::str_view(exemplo, '\\W') # o oposto

### qualquer pontuação: [:punct:]
stringr::str_view(exemplo, '[:punct:]')

### espaços: [:space:] (equivale ao \s)
stringr::str_view(exemplo, '[:space:]')
stringr::str_view(exemplo, '\\s')
stringr::str_view(exemplo, '\\S') # o oposto

## Pode misturar a busca específica
stringr::str_view(exemplo, '[4eA-]') # ou intervalo específico

## limites: início e fim de palavras ('boundary'): '\b' 
stringr::str_view(exemplo, '\\b')
stringr::str_view(exemplo, '\\B') # o oposto


# FUNÇÕES DE BUSCA USANDO REGEX -------------------------------
# regexpr, gregexpr, regexec, gregexec
# funções como sub, gsub, grep, grepl e strsplit tb aceitam buscas usando RegExp

# nomes de espécies
spp <- c("Ocotea porosa", "ocotea porosa", "Ocotea Cf. Porosa", 
         "Ocotea sp.1",  "ocotea sp.10", "eugenia sp.A")

## Localizando padrões usando RegExp
grep('^[A-Z]', spp)
grepl('^[A-Z]', spp)

## Isolando padrões usando RegExp
res1 <- regexpr('^[A-Z]', spp)
regmatches(spp, res1)

## Substituindo padrões usando RegExp
# Corrigindo capitalização
spp.editada <- gsub('(^[a-z])', "\\U\\1", spp, perl = TRUE)
# Corrigindo problema com o cf.
spp.editada <- 
  gsub('\\s(Cf\\.)\\s([A-Z])', " cf. \\L\\2", spp.editada, perl = TRUE)
# Removendo identificadores das morfo-espécies
spp.editada <- 
  gsub('\\ssp\\.[0-9A-Z]+', " sp.", spp.editada, perl = TRUE)
cbind(spp, spp.editada)

## Dividindo por padrões usando RegExp
strsplit(spp.editada, " ")
strsplit(spp.editada, "\\b ")
strsplit(spp.editada, "\\ssp\\.|\\scf\\.|(\\s[a-z]+)")

## Substituição do tipo apagador!
gsub("\\s.*", "", spp.editada) # substituindo qualquer coisa ('.*') após o espaço ('\\s')

## CARACTERES RESERVADOS (metacaracteres e quantificadores) ----------
### barra vertical: '|'
### parenteses, colchetes e chaves: '(', ')', '[', ']', '{', '}'
### circunflexo: '^' (ancora inicial)
### dólar: '$' (ancora final)
### ponto: '.'
### adição: '+'
### interrogação: '?'
### barra inversa: '\' (caractere de escape ou fuga)

### Exemplo sob o uso de caracteres reservados e seu escape no R
exemplo <- "(Espécie - A24)"
sub("é", "e", x = exemplo) # ok!
sub("(", "", x = exemplo) # opa! o que houve?
sub("(", "", exemplo, fixed = TRUE) # ok na busca sem regexp pois '(' é reservado
sub("\(", "", exemplo) # usando o escape '\': ué?
sub("\\(", "", exemplo) #  escapando ambos carateres reservados
sub("\\)", "", exemplo) #  escapando ambos carateres reservados


# 
# ## Exemplo do slide de aula
# texto <- c("esp A", "esp C", "esp B", "esp B", "esp B1")
# grepl('[A-Z]$', texto)


# MANIPULANDO TEXTO DA INTERNET -------------------------
## Discografia dos Beatles
url <- "http://www.textfiles.com/music/DISCOGRAPHY/beatle.33s"
tmp.file <- tempfile()
download.file(url, tmp.file)
(beatles <- readLines(tmp.file))

## Manipulando (limpando)
beatles.limpo <- beatles[grepl("^[a-zA-Z]", beatles)] # seleciona apenas os álbuns
beatles.limpo <- beatles.limpo[!duplicated(beatles.limpo)] # rem. cabeçalho duplicado

## Separando as informações de cada álbum
### usando dois espaços seguidos ou mais
(beatles.split <- strsplit(beatles.limpo, "\\s\\s+")) # ainda não é isso

## Mas alguns álbuns tem informação para '(Solo)' e outros não
## Como o separador das colunas variam entre páginas (!), a separação não funcionou 100%

## Dando um jeitinho...
tira.solo <- function(x) x[!(grepl("^\\(", x) & grepl("\\)$", x))]
beatles.split1 <- lapply(beatles.split, tira.solo)

## Criando uma tabela
beatles.disco <- do.call(rbind.data.frame, beatles.split1)
colnames(beatles.disco) <- beatles.disco[1,]
beatles.disco.final <- beatles.disco[-1, ]

## Toque final
beatles.disco.final[[2]] <- 
  sub(".*\\) ", "", beatles.disco.final[[2]])

## Et voilà !
beatles.disco.final

