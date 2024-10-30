#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#include <mach/mach_host.h>

typedef struct {
    unsigned long free;
    unsigned long total;
} memory_stats_t;

int get_memory_stats(memory_stats_t *stats) {
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS) {
        return -1;
    }
    
    stats->free = vmstat.free_count * vm_page_size;
    stats->total = (vmstat.free_count + vmstat.active_count + vmstat.inactive_count + vmstat.wire_count) * vm_page_size;
    
    return 0;
}

int get_storage_info(const char *path, unsigned long *total, unsigned long *free) {
    struct statfs stats;
    
    if (statfs(path, &stats) == -1) {
        return -1;
    }
    
    *total = stats.f_blocks * stats.f_bsize;
    *free = stats.f_bfree * stats.f_bsize;
    
    return 0;
}

int get_cpu_usage(float *usage) {
    processor_cpu_load_info_t cpu_load;
    mach_msg_type_number_t cpu_count;
    natural_t processor_count;
    
    if (host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &processor_count, 
                           (processor_info_array_t *)&cpu_load, &cpu_count) != KERN_SUCCESS) {
        return -1;
    }
    
    float total_usage = 0;
    for (natural_t i = 0; i < processor_count; i++) {
        unsigned long total = cpu_load[i].cpu_ticks[CPU_STATE_USER] + 
                            cpu_load[i].cpu_ticks[CPU_STATE_SYSTEM] +
                            cpu_load[i].cpu_ticks[CPU_STATE_IDLE];
        float core_usage = ((float)(cpu_load[i].cpu_ticks[CPU_STATE_USER] + 
                                  cpu_load[i].cpu_ticks[CPU_STATE_SYSTEM])) / total;
        total_usage += core_usage;
    }
    
    *usage = (total_usage / processor_count) * 100;
    vm_deallocate(mach_task_self(), (vm_address_t)cpu_load, cpu_count);
    
    return 0;
}