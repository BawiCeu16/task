#!/bin/bash

# Task App - Release Helper Script
# This script helps with local version management and releasing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

get_current_version() {
    grep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1
}

bump_version() {
    local bump_type=$1
    local current=$(get_current_version)
    IFS='.' read -r major minor patch <<< "$current"
    
    case $bump_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type"
            exit 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Main menu
show_menu() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║   Task App - Release Helper           ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    echo "Current version: $(get_current_version)"
    echo ""
    echo "Select an option:"
    echo "  1) View current version"
    echo "  2) Bump patch version (and release)"
    echo "  3) Bump minor version (and release)"
    echo "  4) Bump major version (and release)"
    echo "  5) Manual release (tag only)"
    echo "  6) Show git tags"
    echo "  7) Exit"
    echo ""
}

# Option 1: View version
view_version() {
    print_info "Current version: $(get_current_version)"
    local version_line=$(grep '^version:' pubspec.yaml)
    print_info "Full version string: $version_line"
}

# Option 2-4: Bump and release
bump_and_release() {
    local bump_type=$1
    local current=$(get_current_version)
    local new_version=$(bump_version $bump_type)
    
    echo ""
    print_info "Bumping $bump_type: $current → $new_version"
    echo ""
    
    # Update pubspec.yaml
    sed -i.bak "s/^version: .*/version: $new_version+$RANDOM/" pubspec.yaml
    rm -f pubspec.yaml.bak
    print_success "Updated pubspec.yaml"
    
    # Commit
    git add pubspec.yaml
    git commit -m "chore: bump version to $new_version"
    print_success "Committed version bump"
    
    # Tag
    git tag -a "v$new_version" -m "Release v$new_version"
    print_success "Created tag v$new_version"
    
    # Push
    echo ""
    print_info "Ready to push. Run these commands:"
    echo "  git push origin $(git rev-parse --abbrev-ref HEAD)"
    echo "  git push origin v$new_version"
    echo ""
    
    read -p "Push now? (y/n): " -n 1 -r
    echo  
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin $(git rev-parse --abbrev-ref HEAD)
        git push origin v$new_version
        print_success "Pushed version $new_version!"
        print_info "GitHub Actions will now build the APK"
    else
        print_info "Push skipped. Remember to push later!"
    fi
}

# Option 5: Manual release
manual_release() {
    read -p "Enter version number (e.g., 1.4.0): " version
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format"
        return
    fi
    
    read -p "Create tag? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -a "v$version" -m "Release v$version"
        print_success "Created tag v$version"
        git push origin v$version
        print_success "Pushed tag. GitHub Actions will build the APK"
    fi
}

# Option 6: Show tags
show_tags() {
    echo ""
    echo "Recent git tags:"
    git tag -l -n 1 --sort=-version:refname | head -10
    echo ""
}

# Main loop
while true; do
    show_menu
    read -p "Enter choice [1-7]: " choice
    
    case $choice in
        1) view_version ;;
        2) bump_and_release "patch" ;;
        3) bump_and_release "minor" ;;
        4) bump_and_release "major" ;;
        5) manual_release ;;
        6) show_tags ;;
        7) print_success "Goodbye!"; exit 0 ;;
        *) print_error "Invalid option" ;;
    esac
done
