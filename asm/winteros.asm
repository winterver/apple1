        PROCESSOR 65C02
        ORG 0xF000
ENTRY   WAI
        LDA 0xD000
        STA 0xD000
        BRA ENTRY

IRQ     /* TODO Interrupt Service Routine */
NMI     RTI /* Set NMI entry to the trailing RTI of IRQ */
            /* Currently no plan to implement NMI */

        ORG 0xFFFA
        WORD NMI
        WORD ENTRY
        WORD IRQ
