// #ifndef LIMINE_API_REVISION
//     #define LIMINE_API_REVISION 3
// #endif

// #include <limine/limine.h>

// struct LimineRes
// {
//     uint64_t                         hhdm;
//     limine_framebuffer_response     *fb;
//     limine_module_response          *modules;
//     limine_memmap_response          *mmaps;
//     limine_executable_file_response *fh;
//     limine_executable_address_response *execaddr;
//     limine_rsdp_response            *rsdp;
//     limine_mp_response              *mp;
// };


// __attribute__((used, section(".limine_requests")))
// static volatile LIMINE_BASE_REVISION(3);


// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_hhdm_request lim_hhdm_req = {
//     .id = LIMINE_HHDM_REQUEST,
//     .revision = 3
// };

// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_framebuffer_request lim_fb_req = {
//     .id = LIMINE_FRAMEBUFFER_REQUEST,
//     .revision = 3
// };

// __attribute__((used, section(".limine_requests")))
// volatile struct limine_module_request lim_module_req = {
//     .id = LIMINE_MODULE_REQUEST,
//     .revision = 3
// };

// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_memmap_request lim_mmap_req = {
//     .id = LIMINE_MEMMAP_REQUEST,
//     .revision = 3
// };


// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_executable_file_request lim_execfile_req = {
//     .id = LIMINE_EXECUTABLE_FILE_REQUEST,
//     .revision = 3
// };


// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_executable_address_request lim_execaddr_req = {
//     .id = LIMINE_EXECUTABLE_ADDRESS_REQUEST,
//     .revision = 3
// };


// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_rsdp_request lim_rsdp_req = {
//     .id = LIMINE_RSDP_REQUEST,
//     .revision = 3
// };


// __attribute__((used, section(".limine_requests")))
// static volatile struct limine_mp_request lim_mp_req = {
//     .id = LIMINE_MP_REQUEST,
//     .revision = 3
// };


// __attribute__((used, section(".limine_requests_start")))
// static volatile LIMINE_REQUESTS_START_MARKER;

// __attribute__((used, section(".limine_requests_end")))
// static volatile LIMINE_REQUESTS_END_MARKER;


// // const char *mmap_str( uint32_t type )
// // {
// //     switch (type)
// //     {
// //         default: return "UNKNOWN_TYPE";
// //         case LIMINE_MEMMAP_USABLE: return "LIMINE_MEMMAP_USABLE";
// //         case LIMINE_MEMMAP_RESERVED: return "LIMINE_MEMMAP_RESERVED";
// //         case LIMINE_MEMMAP_ACPI_RECLAIMABLE: return "LIMINE_MEMMAP_ACPI_RECLAIMABLE";
// //         case LIMINE_MEMMAP_ACPI_NVS: return "LIMINE_MEMMAP_ACPI_NVS";
// //         case LIMINE_MEMMAP_BAD_MEMORY: return "LIMINE_MEMMAP_BAD_MEMORY";
// //         case LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE: return "LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE";
// //         case LIMINE_MEMMAP_EXECUTABLE_AND_MODULES:  return "LIMINE_MEMMAP_EXECUTABLE_AND_MODULES";
// //         case LIMINE_MEMMAP_FRAMEBUFFER: return "LIMINE_MEMMAP_FRAMEBUFFER";
// //     }
// // }

// LimineRes limine_res;

// void LimineRes_init()
// {
//     limine_res = {
//         .hhdm     = lim_hhdm_req.response->offset,
//         .fb       = lim_fb_req.response,
//         .modules  = lim_module_req.response,
//         .mmaps    = lim_mmap_req.response,
//         .fh       = lim_execfile_req.response,
//         .execaddr = lim_execaddr_req.response,
//         .rsdp     = lim_rsdp_req.response,
//         .mp       = lim_mp_req.response
//     };

// }








// #include <kmemxx.hpp>
// #include <cpu/cpu.hpp>


// extern "C"
// {
//     extern uint8_t __bss_start[];
//     extern uint8_t __bss_end[];
// }


// void knl_ClearBSS()
// {
//     CPU::stos64(__bss_start, 0, (__bss_end-__bss_start)/sizeof(uint64_t));
//     // kmemset<uint128_t>(__bss_start, 0, __bss_end-__bss_start);
// }


// void knl_ClearMemory()
// {
//     size_t hhdm  = lim_hhdm_req.response->offset;
//     size_t count = lim_mmap_req.response->entry_count;
//     auto  *mmaps = lim_mmap_req.response->entries;

//     for (size_t i=0; i<count; i++)
//     {
//         if (mmaps[i]->type == LIMINE_MEMMAP_USABLE)
//         {
//             uint8_t *base = (uint8_t*)(mmaps[i]->base) + hhdm;
//             CPU::stos64(base, 0, mmaps[i]->length / sizeof(uint64_t));
//             // kmemset<uint8_t>(base, 0, mmaps[i]->length);
//         }
//     }
// }





// extern "C"
// void _start( void )
// {
//     asm ("cli");

//     CPU::createGDT();
//     CPU::installGDT();
//     CPU::initFoat();

//     (serial::init()) ? syslog::enable() : syslog::disable();
//     early_init();
//     CPU_featureCheck2();

//     PIC::disable();
//     CPU::createIDT();
//     CPU::installIDT();

//     CPU::installISR(IntNo_PageFault,     pagefaultISR);
//     CPU::installISR(IntNo_OUT_OF_MEMORY, outOfMemoryISR);
//     CPU::installISR(IntNo_KThreadYield,  knl::Sched::scheduleISR);
//     CPU::installISR(IntNo_Syscall,       syscallISR);
//     CPU::installISR(IntNo_Spurious,      spuriousISR);
//     CPU::installIRQ(IrqNo_PIT,           PIT_IrqHandler);

//     static ACPI::Response res;
//     ACPI::init(limine_res.rsdp->address, res);
//     APIC::init(res);

//     // ustar::listAll(initrd::tarball);

//     // void *handle = knl::dl_open("usr/lib/libc.a");
//     // syslog::println("handle: 0x%lx", handle);
//     // void *addr1  = knl::sym_load(handle, "ulibc_add");
//     // syslog::println("addr1:  0x%lx", addr1);

//     // auto testfn = (int (*)(int, int))addr1;
//     // syslog::println("YOLO\n");
//     // int value = testfn(2, 98);
//     // syslog::println("res: %d\n", value);

//     barrierA.reset(limine_res.mp->cpu_count);
//     SMP::init(kmain);

//     kassert(false); // Should be unreachable!

//     CPU::hcf();
// }

