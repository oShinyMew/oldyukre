#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/mach.h>
#include <mach/mach_error.h>
#include <mach-o/dyld.h>

typedef struct {
    void *address;
    size_t size;
} kernel_patch_t;

static kernel_patch_t *patches = NULL;
static size_t patch_count = 0;

int init_kernel_ops() {
    kern_return_t kr;
    mach_port_t tfp0 = MACH_PORT_NULL;
    
    kr = task_for_pid(mach_task_self(), 0, &tfp0);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    patches = malloc(sizeof(kernel_patch_t) * 10);
    if (!patches) {
        return -2;
    }
    
    return 0;
}

int apply_kernel_patch(void *address, const void *data, size_t size) {
    if (!patches || patch_count >= 10) {
        return -1;
    }
    
    kern_return_t kr;
    vm_address_t patch_addr = (vm_address_t)address;
    
    kr = vm_protect(mach_task_self(), patch_addr, size, FALSE, VM_PROT_READ | VM_PROT_WRITE);
    if (kr != KERN_SUCCESS) {
        return -2;
    }
    
    memcpy((void *)patch_addr, data, size);
    
    patches[patch_count].address = address;
    patches[patch_count].size = size;
    patch_count++;
    
    return 0;
}

int revert_kernel_patches() {
    for (size_t i = 0; i < patch_count; i++) {
        kern_return_t kr;
        vm_address_t patch_addr = (vm_address_t)patches[i].address;
        
        kr = vm_protect(mach_task_self(), patch_addr, patches[i].size, FALSE, VM_PROT_READ | VM_PROT_WRITE);
        if (kr != KERN_SUCCESS) {
            continue;
        }
    }
    
    free(patches);
    patches = NULL;
    patch_count = 0;
    
    return 0;
}

int get_kernel_version(char *version, size_t size) {
    size_t len = size;
    if (sysctlbyname("kern.version", version, &len, NULL, 0) == -1) {
        return -1;
    }
    return 0;
}