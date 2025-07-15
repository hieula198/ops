# -------- CONFIG --------
PYTHON := python3
INVENTORY ?= staging
PLAYBOOK := playbook.yml
SSH_KEY := keys/id_rsa

# -------- DEFAULT TARGET --------
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make install           Install Ansible via pip"
	@echo "  make gen-ssh-key       Generate SSH key (if not exists)"
	@echo "  make apply INVENTORY=staging|production   Run Ansible playbook"
	@echo "  make all               Install, gen key, and apply"

# -------- INSTALL ANSIBLE --------
.PHONY: install
install:
	@echo "Checking and installing Ansible..."
	@$(PYTHON) -m pip install --user ansible || true
	@echo "✅ Ansible installed"

# -------- GENERATE SSH KEY --------
.PHONY: gen-ssh-key
gen-ssh-key:
	@mkdir -p ./keys
	@if [ ! -f $(SSH_KEY) ]; then \
		echo "🔑 Generating SSH key..."; \
		ssh-keygen -t rsa -b 4096 -f $(SSH_KEY) -N "" -C "on-premise"; \
	else \
		echo "🔑 SSH key already exists at $(SSH_KEY)"; \
	fi

# -------- RUN ANSIBLE --------
.PHONY: apply
apply:
	@if [ ! -d "inventory/$(INVENTORY)" ]; then \
		echo "❌ Inventory '$(INVENTORY)' not found in ./inventory/"; \
		exit 1; \
	fi
	@echo "🚀 Running Ansible playbook with inventory: $(INVENTORY)"
	@ansible-playbook -i inventory/$(INVENTORY) $(PLAYBOOK) --private-key=$(SSH_KEY)

# -------- COMBO --------
.PHONY: all
all: install gen-ssh-key apply
