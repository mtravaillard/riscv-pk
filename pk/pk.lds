/* See LICENSE for license details. */

OUTPUT_ARCH( "riscv" )

ENTRY( reset_vector )

MEMORY {
  /* We assume at least 64 KiB SPM*/
  spm (rwx)     : ORIGIN = 0x10000000, LENGTH = 64K
  /* We  assume at least 8 MiB of DRAM (minimum for Linux). */
  dram (rwx)    : ORIGIN = 0x80000000, LENGTH = 8M
}

SECTIONS
{

  /*--------------------------------------------------------------------*/
  /* Code and read-only segment                                         */
  /*--------------------------------------------------------------------*/

  /*--------------------------------------------------------------------*/
  /* HTIF, isolated onto separate page                                  */
  /*--------------------------------------------------------------------*/
  . = 0x10000000;
  .htif :
  {
    PROVIDE( __htif_base = . );
    *(.htif)
  } > spm


  /* Begining of code and text segment */
  . = MEM_START;
  _ftext = .;

  .text :
  {
    *(.text.init)
  } > dram

  /* text: Program code section */
  .text : 
  {
    *(.text)
    *(.text.*)
    *(.gnu.linkonce.t.*)
  } > dram

  /* rodata: Read-only data */
  .rodata : 
  {
    *(.rdata)
    *(.rodata)
    *(.rodata.*)
    *(.gnu.linkonce.r.*)
  } > dram

  /* End of code and read-only segment */
  . = ALIGN(0x1000);
  _etext = .;

  /*--------------------------------------------------------------------*/
  /* Initialized data segment                                           */
  /*--------------------------------------------------------------------*/

  /* Start of initialized data segment */
  . = ALIGN(16);
   _fdata = .;

  /* data: Writable data */
  .data : 
  {
    *(.data)
    *(.data.*)
    *(.srodata*)
    *(.gnu.linkonce.d.*)
    *(.comment)
    *(.dtb)
  } > dram

  /* End of initialized data segment */
  . = ALIGN(16);
  _edata = .;

  /*--------------------------------------------------------------------*/
  /* Uninitialized data segment                                         */
  /*--------------------------------------------------------------------*/

  /* Start of uninitialized data segment */
  . = .;
  _fbss = .;

  /* sbss: Uninitialized writeable small data section */
  . = .;

  /* bss: Uninitialized writeable data section */
  . = .;
  _bss_start = .;
  .bss : 
  {
    *(.bss)
    *(.bss.*)
    *(.sbss*)
    *(.gnu.linkonce.b.*)
    *(COMMON)
  } > dram

  . = ALIGN(0x1000);
  _end = .;
}