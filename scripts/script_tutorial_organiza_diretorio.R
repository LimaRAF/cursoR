# SCRIPT PARA O TUTORIAL SOBRE ORGANIZAÇÃO DE DIRETOÓRIOS #
# Autor: Renato A. Ferreira de Lima
# Email: raflima@usp.br
# Data: 12/09/2024

## Salvando nomes dos objetos da área de trabalho
obj.to.keep <- ls()

## Lendo os dados
dados <- read.csv(file.path("data", "raw-data", "caixeta.csv"))

## Editando os dados
### Obtendo o diâmetro por fuste em cm (dados originais em mm)
dados$cap_cm <- dados$cap/10 
dados$dap_cm <- dados$cap_cm/pi 

### Obtendo a altura em metros (dados originais em cm)
dados$h_m <- dados$h/10 

### Corrigindo os nomes das espécies
### Algumas espécies com grafia errônea ou nomes populares
spp <- c("Syagrus romanzoffianus", "Calophyllum brasiliensis",
         "Callophyllum brasiliensis",
         "Coussapoa macrocarpa", "Cryptocaria moschata", 
         "Ilex durosa", "jussara",
         "Tibouchina nutticeps")
spp.correct <- c("Syagrus romanzoffiana", "Calophyllum brasiliense",
                 "Calophyllum brasiliense",
                 "Coussapoa microcarpa", "Cryptocarya moschata", 
                 "Ilex dumosa", "Euterpe edulis",
                 "Tibouchina multiceps")  
for (i in seq_along(spp)) 
  dados$especie[dados$especie %in% spp[i]] <- spp.correct[i]

### Calculando volume por fuste 
### usando os defaults dos argumentos que representam o volume pela equaao de Schumacher-Hall (1933)
dados$volume <- eq_volume(dados$dap_cm)

## Gerando e salvando a figura com a exploração do dados de dap_cm e volume 
### Figura 1
jpeg(filename = "output/Figura1_AED.jpg", width = 960/1.2, height = 480/1.2, 
     units = "px", pointsize = 12, quality = 300,
     bg = "white", res = NA, restoreConsole = TRUE)
par(mfrow = c(1,2), mgp = c(2,0.5,0), mar=c(4,3,1,0.5),
    tcl = -0.25)
hist(dados$dap_cm, las = 1, main = "", cex.lab = 1.2,
     xlab = "DAP (cm)")
legend("topright", "A)", bty = "n", cex = 1.2)

boxplot(log(volume) ~ local, data = dados, 
        las = 1, cex.lab = 1.2, xlab = "Local",
        notch = TRUE, varwidth = TRUE)
legend("topright", "B)", bty = "n", cex = 1.2)
dev.off()

## Tabela com a estatítistica descritiva do volume por localidade
medias_por_loc <- tapply(dados$volume, dados$local, mean)
sd_por_loc <- tapply(dados$volume, dados$local, sd)
arv_por_loc <- tapply(dados$volume, dados$local, length)

tabela1 <- data.frame(Local = names(medias_por_loc),
                     Arvores = arv_por_loc,
                     Media = round(medias_por_loc, 3),
                     DesvPad = round(sd_por_loc, 3))
row.names(tabela1) <- NULL
tabela1$Local <- gsub("(^[a-z])", "\\U\\1", tabela1$Local, perl = T)

## Há diferença entre o logaritimo dos volumes das três áreas?
### dados de volume não-normais sendo transformados antes das análises
mod <- lm(log(volume) ~ local, data = dados)
mod_anova <- anova(mod)

## Tabela da ANOVA
tabela2 <- data.frame(Fonte = c("Entre grupos", "Dentre grupos", "Total"),
                      SQ = c(round(mod_anova$`Sum Sq`[1], 2), 
                             round(mod_anova$`Sum Sq`[2] - mod_anova$`Sum Sq`[1], 2),
                             round(mod_anova$`Sum Sq`[2], 2)),
                      GL = c(round(mod_anova$Df[1], 2),
                             round(mod_anova$Df[2] - mod_anova$Df[1], 2),
                             round(mod_anova$Df[2], 2)),
                      Media_Q = c(round(mod_anova$`Mean Sq`[1], 2),
                                  round(mod_anova$`Mean Sq`[2], 2), ""),
                      F_test = c(round(mod_anova$`F value`[1],1), "",""),
                      p_valor = c(signif(mod_anova$`Pr(>F)`[1],4), "",""))

## Salvando as tabelas (no formato padrão de Excel em português)
write.csv2(tabela1, "output/Tabela1_AED.csv", row.names = FALSE)
write.csv2(tabela2, "output/Tabela2_ANOVA.csv", row.names = FALSE)

## Limpando 
all.objs <- ls()
rm.objs <- all.objs[!all.objs %in% obj.to.keep]
rm(list = rm.objs)

# Fim do script
