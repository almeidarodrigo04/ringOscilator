# capture_loop.tcl
#
# Roda dentro do System Console do Quartus (Tools -> System Console, ou
# via linha de comando "system-console -cli"). Não precisa instalar nada
# extra -- System Console já vem com qualquer instalação do Quartus.
#
# O que este script faz:
#   1) Conecta no primeiro "master" JTAG-to-Avalon encontrado (a ponte
#      que você montou no Platform Designer)
#   2) Repete N vezes:
#        - escreve 1 no registrador de controle do capture_buffer -> inicia a captura
#        - fica checando (poll) o bit "done" até a captura terminar
#        - lê todo o buffer em blocos e grava os bytes num arquivo local
#   3) No final, fecha tudo
#
# --------------------------------------------------------------------
# AJUSTE ESTES 3 VALORES conforme o que você configurou no capture_buffer:
# --------------------------------------------------------------------
set CONTROL_ADDR   0x0
set BUFFER_BASE    0x2000   ;# = 2^BUFFER_ADDR_BITS (bit de seleção memória)
set BUFFER_SIZE    8192     ;# quantidade de palavras/bytes no buffer
set READ_CHUNK     1024     ;# quantas palavras ler por chamada (evita 1 chamada gigante)
set NUM_CAPTURAS   50       ;# quantas rodadas de captura fazer (ajuste ao volume de dados desejado)
set OUTPUT_FILE    "trng_log.txt"
set BITS_POR_LINHA 64       ;# quebra de linha a cada N bits, só para o arquivo ficar legível (0 = sem quebra)

# --------------------------------------------------------------------
# Conecta ao master
# --------------------------------------------------------------------
set master_paths [get_service_paths master]
if {[llength $master_paths] == 0} {
    puts "ERRO: nenhum serviço 'master' encontrado. A FPGA está programada e o cabo conectado?"
    exit 1
}
set mfd [lindex $master_paths 0]
open_service master $mfd
puts "Conectado ao master: $mfd"

# --------------------------------------------------------------------
# DIAGNÓSTICO: confirma se BUFFER_BASE está caindo mesmo na memória
# (e não sendo relido como o registrador de controle, por causa de
# "Address units" configurado como SYMBOLS em vez de WORDS no
# Component Editor). Roda automaticamente antes do loop principal.
# --------------------------------------------------------------------
puts "--- Diagnóstico de endereçamento ---"

master_write_32 $mfd $CONTROL_ADDR 0x1
set done 0
while {!$done} {
    set status [master_read_32 $mfd $CONTROL_ADDR 1]
    if {[expr {[lindex $status 0] & 0x2}] != 0} { set done 1 }
}
set ctrlVal [lindex [master_read_32 $mfd $CONTROL_ADDR 1] 0]
puts "  Registrador de controle (endereço $CONTROL_ADDR) apos captura: $ctrlVal (esperado: 2 = done, sem capturar)"

set memTestBase [master_read_32 $mfd $BUFFER_BASE 4]
puts "  Primeiras 4 palavras lidas em BUFFER_BASE ($BUFFER_BASE): $memTestBase"

set memTestScaled [master_read_32 $mfd [expr {$BUFFER_BASE * 4}] 4]
puts "  Primeiras 4 palavras lidas em BUFFER_BASE*4 ([expr {$BUFFER_BASE * 4}]): $memTestScaled"

if {[lindex $memTestBase 0] == $ctrlVal && [lindex $memTestBase 1] == $ctrlVal} {
    puts "  AVISO: os valores em BUFFER_BASE são iguais ao registrador de controle ($ctrlVal repetido)."
    puts "  Isso indica que o endereço não está de fato alcançando a memória -- muito provavelmente"
    puts "  'Address units' está como SYMBOLS em vez de WORDS no capture_buffer (ver Component Editor)."
    puts "  Compare com a linha 'BUFFER_BASE*4' acima: se ELA variar/parecer dado real do TRNG,"
    puts "  troque BUFFER_BASE para [expr {$BUFFER_BASE * 4}] neste script e rode de novo."
} else {
    puts "  OK: os valores em BUFFER_BASE parecem distintos do registrador de controle."
}
puts "--- Fim do diagnóstico ---"
puts ""

set fp [open $OUTPUT_FILE "w"]
set bitsEscritos 0

for {set captura 0} {$captura < $NUM_CAPTURAS} {incr captura} {

    puts "Captura $captura de $NUM_CAPTURAS ..."

    # Inicia a captura
    master_write_32 $mfd $CONTROL_ADDR 0x1

    # Espera terminar (poll do bit "done" = bit 1)
    set done 0
    while {!$done} {
        set status [master_read_32 $mfd $CONTROL_ADDR 1]
        set statusVal [lindex $status 0]
        if {[expr {$statusVal & 0x2}] != 0} {
            set done 1
        }
    }

    # Lê o buffer inteiro em blocos e grava no arquivo
    set lidos 0
    while {$lidos < $BUFFER_SIZE} {
        set n [expr {min($READ_CHUNK, $BUFFER_SIZE - $lidos)}]
        set addr [expr {$BUFFER_BASE + $lidos}]
        set words [master_read_32 $mfd $addr $n]
        foreach w $words {
            # cada palavra tem o byte capturado nos 8 bits menos significativos
            set byteVal [expr {$w & 0xFF}]
            # escreve do bit 7 (mais antigo, chegou primeiro) ao bit 0 (mais recente)
            for {set b 7} {$b >= 0} {incr b -1} {
                set bitVal [expr {($byteVal >> $b) & 0x1}]
                puts -nonewline $fp $bitVal
                incr bitsEscritos
                if {$BITS_POR_LINHA > 0 && [expr {$bitsEscritos % $BITS_POR_LINHA}] == 0} {
                    puts $fp ""
                }
            }
        }
        incr lidos $n
    }
}

close $fp
close_service master $mfd
puts "Concluído. Dados salvos em $OUTPUT_FILE"
