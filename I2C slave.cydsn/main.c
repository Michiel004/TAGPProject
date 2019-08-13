/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#include "project.h"

int main(void)
{
   
    uint8 i2cbuf[3];
    i2cbuf[0] = 7;
    i2cbuf[1] = 8;
    i2cbuf[2] = 9;
    
    int16 result = 0;
   // CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    
   

    
    EZI2C_EzI2CSetBuffer1(3,0,i2cbuf);
    
    EZI2C_Start();
    
    CyGlobalIntEnable;
    
    ADC_SAR_Seq_1_Start(); /* Initialize ADC */
    ADC_SAR_Seq_1_IRQ_Enable(); /* Enable ADC interrupts */
    ADC_SAR_Seq_1_StartConvert(); /* Start ADC conversions */
    
    for(;;)
    {
        /* Place your application code here. */
        i2cbuf[0] = result = ADC_SAR_Seq_1_GetResult16(0);
        i2cbuf[1] = result = ADC_SAR_Seq_1_GetResult16(1);
        i2cbuf[2] = result = ADC_SAR_Seq_1_GetResult16(2);
    }
}

/* [] END OF FILE */
