# Adding Dotfiles to macOS Shortcuts App

This guide shows you how to add your dotfiles management commands to the macOS Shortcuts app for quick access from anywhere.

## Method 1: Create Shortcuts from .command Files

### Step 1: Open Shortcuts App
1. Open the **Shortcuts** app (found in Applications or use Spotlight)
2. Click the **+** button to create a new shortcut

### Step 2: Add "Run Shell Script" Action
1. Search for "Run Shell Script" in the actions library
2. Drag it to your shortcut workspace

### Step 3: Configure the Script
1. In the "Run Shell Script" action, set:
   - **Shell**: `/bin/bash`
   - **Pass input**: `as arguments`
2. In the script field, enter:
   ```bash
   cd "/Volumes/vaultex/.dotfiles"
   ./setup-dotfiles.command
   ```

### Step 4: Name and Save
1. Click the shortcut name at the top
2. Name it "Setup Dotfiles"
3. Click **Done**

### Step 5: Repeat for Other Commands
Create similar shortcuts for each command:

| Shortcut Name | Script |
|---------------|--------|
| Setup Dotfiles | `cd "/Volumes/vaultex/.dotfiles" && ./setup-dotfiles.command` |
| Update Dotfiles | `cd "/Volumes/vaultex/.dotfiles" && ./update-dotfiles.command` |
| Check Status | `cd "/Volumes/vaultex/.dotfiles" && ./check-status.command` |
| Start Services | `cd "/Volumes/vaultex/.dotfiles" && ./start-services.command` |
| Backup Dotfiles | `cd "/Volumes/vaultex/.dotfiles" && ./backup-dotfiles.command` |
| Cleanup Dotfiles | `cd "/Volumes/vaultex/.dotfiles" && ./cleanup-dotfiles.command` |

## Method 2: Create Advanced Shortcuts with Notifications

### Enhanced Setup Shortcut
1. Create a new shortcut
2. Add these actions in order:

**Action 1: Show Notification**
- Title: "Setting up dotfiles..."
- Message: "Please wait while I configure your system"

**Action 2: Run Shell Script**
```bash
cd "/Volumes/vaultex/.dotfiles"
./setup-dotfiles.command
```

**Action 3: Show Notification**
- Title: "Setup Complete!"
- Message: "Your dotfiles have been configured successfully"

### Enhanced Status Check Shortcut
1. Create a new shortcut
2. Add these actions:

**Action 1: Run Shell Script**
```bash
cd "/Volumes/vaultex/.dotfiles"
./check-status.command
```

**Action 2: Show Result**
- Display the output in a notification or alert

## Method 3: Create a Menu Shortcut

### Dotfiles Menu Shortcut
Create a shortcut that shows a menu of all options:

1. Add "Choose from Menu" action
2. Add menu items:
   - Setup Dotfiles
   - Update Dotfiles
   - Check Status
   - Start Services
   - Backup Dotfiles
   - Cleanup Dotfiles
3. For each menu item, add a "Run Shell Script" action with the appropriate command

## Method 4: Add to Control Center

### Make Shortcuts Available Everywhere
1. Open **System Preferences** → **Dock & Menu Bar**
2. Find **Shortcuts** in the list
3. Check the box to show it in the menu bar
4. Your dotfiles shortcuts will now be accessible from the menu bar

## Method 5: Add to Dock

### Quick Dock Access
1. Right-click on any shortcut in the Shortcuts app
2. Select **Add to Dock**
3. The shortcut will appear in your Dock for quick access

## Method 6: Create Keyboard Shortcuts

### Assign Keyboard Shortcuts
1. Open **System Preferences** → **Keyboard** → **Shortcuts**
2. Select **App Shortcuts** from the left sidebar
3. Click the **+** button
4. Choose **Shortcuts** as the Application
5. Enter the exact name of your shortcut
6. Assign a keyboard shortcut (e.g., ⌘⇧D for "Setup Dotfiles")

## Method 7: Add to Spotlight

### Spotlight Integration
1. In the Shortcuts app, right-click on a shortcut
2. Select **Add to Siri**
3. Give it a phrase like "Setup my dotfiles"
4. Now you can say "Hey Siri, setup my dotfiles" or search in Spotlight

## Advanced: Conditional Shortcuts

### Smart Setup Shortcut
Create a shortcut that checks if the external drive is mounted:

```bash
if [ -d "/Volumes/vaultex" ]; then
    cd "/Volumes/vaultex/.dotfiles"
    ./setup-dotfiles.command
else
    echo "External drive not mounted. Please mount it first."
fi
```

### Backup Before Update Shortcut
Create a shortcut that backs up before updating:

```bash
cd "/Volumes/vaultex/.dotfiles"
./backup-dotfiles.command
./update-dotfiles.command
```

## Troubleshooting

### Shortcut Not Working
1. **Check path**: Make sure the path to your dotfiles is correct
2. **Permissions**: Ensure the .command files are executable
3. **Drive mounted**: Verify the external drive is mounted

### Permission Issues
If you get permission errors:
1. Open **System Preferences** → **Security & Privacy**
2. Go to **Privacy** tab
3. Select **Accessibility** or **Full Disk Access**
4. Add **Shortcuts** to the allowed applications

### Terminal Not Opening
If the terminal doesn't open:
1. Make sure the .command files have execute permissions
2. Try using the full path to the script
3. Check that the external drive is mounted

## Tips

### Organization
- Create a folder in Shortcuts called "Dotfiles"
- Group all your dotfiles shortcuts together
- Use consistent naming (e.g., "Dotfiles: Setup", "Dotfiles: Update")

### Customization
- Add custom icons to your shortcuts
- Use different colors for different types of actions
- Add helpful comments in the shortcut descriptions

### Automation
- Set up shortcuts to run automatically at login
- Create shortcuts that run on specific triggers
- Use Siri to voice-activate your dotfiles commands

## Example Shortcuts Collection

Here's a complete collection you can create:

1. **Dotfiles Setup** - Basic setup command
2. **Dotfiles Update** - Update from git
3. **Dotfiles Status** - Check system status
4. **Dotfiles Services** - Start window management
5. **Dotfiles Backup** - Create backup
6. **Dotfiles Cleanup** - Clean up files
7. **Dotfiles Menu** - All options in one menu
8. **Dotfiles Smart Update** - Backup then update

This gives you a complete dotfiles management system accessible from anywhere on your Mac! 🎯
