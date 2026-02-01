# Makefile for Hytale Plugin Development
# Use 'make <command>' to run tasks

# Detect OS and set appropriate gradle wrapper command
ifeq ($(OS),Windows_NT)
    GRADLE_WRAPPER = gradlew.bat
else
    GRADLE_WRAPPER = ./gradlew
endif

# Optional: Set Hytale home path (e.g., make setup-vscode HYTALE_HOME=/path/to/hytale)
ifdef HYTALE_HOME
    GRADLE_PROPS = -Phytale_home=$(HYTALE_HOME)
else
    GRADLE_PROPS =
endif

.PHONY: help build clean run test assemble install setup-vscode shadow-jar shaded

# Default command
help:
	@echo "Available commands:"
	@echo "  make build          - Build the complete plugin"
	@echo "  make clean          - Remove build files"
	@echo "  make run            - Run Hytale server with the plugin"
	@echo "  make assemble       - Create plugin JAR"
	@echo "  make shadow-jar     - Build shaded JAR with dependencies"
	@echo "  make shaded         - Alias for shadow-jar"
	@echo "  make install        - Copy JAR to Hytale mods folder"
	@echo "  make test           - Run tests (if available)"
	@echo "  make setup-vscode   - Generate VS Code debug configuration"
	@echo "  make update-manifest - Update manifest.json with properties"
	@echo ""
	@echo "Optional environment variables:"
	@echo "  HYTALE_HOME         - Path to Hytale installation (e.g., make setup-vscode HYTALE_HOME=/path/to/hytale)"

# Build the complete project
build:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) build

# Remove build files
clean:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) clean

# Create plugin JAR
assemble:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) assemble

# Build shaded JAR with all dependencies
shadow-jar:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) shadowJar

# Alias for shadow-jar
shaded: shadow-jar

# Run tests
test:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) test

# Update manifest.json
update-manifest:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) updatePluginManifest

# Generate VS Code debug configuration
setup-vscode:
	@$(GRADLE_WRAPPER) $(GRADLE_PROPS) generateVSCodeLaunch

# Install plugin to Hytale mods folder
install: assemble
ifeq ($(OS),Windows_NT)
	@powershell -Command "Copy-Item -Path './build/libs/*.jar' -Destination '$$env:APPDATA/Hytale/UserData/Mods/' -Force"
	@echo "Plugin installed to %APPDATA%/Hytale/UserData/Mods/"
else
	@cp ./build/libs/*.jar ~/.local/share/Hytale/UserData/Mods/ 2>/dev/null || mkdir -p ~/.local/share/Hytale/UserData/Mods && cp ./build/libs/*.jar ~/.local/share/Hytale/UserData/Mods/
	@echo "Plugin installed to ~/.local/share/Hytale/UserData/Mods/"
endif
