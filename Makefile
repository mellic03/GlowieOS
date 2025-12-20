# Nuke built-in rules.
.SUFFIXES:

include ./makefiles/env.mk

KERNEL_ISO := $(BUILD_DIR)/glowie.iso

.PHONY: all
all: $(KERNEL_ISO) libc.a

$(KERNEL_ISO): kernel.elf init_rd
	@echo "Copying limine binaries..."
	@mkdir -p $(ISO_DIR)/boot $(ISO_DIR)/EFI/BOOT
	@cp $(KNL_DIR)/limine.conf $(AUX_DIR)/share/limine/limine-* $(ISO_DIR)/boot/
	@cp $(AUX_DIR)/share/limine/BOOT*.EFI $(ISO_DIR)/EFI/BOOT/
	@echo "Copied limine binaries"
	@echo "Generating ISO image..."
	@xorriso \
		-as mkisofs -R -r -J \
		-b boot/limine-bios-cd.bin -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-hfsplus -apm-block-size 2048 \
		--efi-boot boot/limine-uefi-cd.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label \
		$(ISO_DIR) -o $(KERNEL_ISO) 
	@$(AUX_DIR)/bin/limine bios-install $(KERNEL_ISO)
	@echo "Generated ISO image"

include kernel/Makefile

init_rd: iso_dir
	@echo "Creating initrd..."
	tar -czf $(ISO_DIR)/initrd.tar.gz -C $(ROOT_DIR)/kernel/sysroot .
	@echo "Created initrd"

iso_dir:
	@echo "Creating iso_root..."
	mkdir -p $(ISO_DIR)
	@echo "Created iso_root"

include ${GLOWIE_ROOT_DIR}/makefiles/compile_rules.mk

include lib/libc/Makefile