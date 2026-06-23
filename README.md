# CanvasBar

A macOS menu bar app that pulls in your Canvas LMS assignments from your calendar feed and keeps them a click away.

## Features

- Fetches assignments from your Canvas .ics calendar feed
- Check off assignments with persistent checkboxes
- Add notes to individual assignments
- Auto-refreshes in the background
- Launch at login toggle
- Sits in your menu bar and stays out of the way

## Requirements

- macOS 13 (Ventura) or later
- A Canvas LMS account with calendar feed access

## Installation

Download the latest `.zip` from the [Releases](https://github.com/adikasar3/CanvasBar/releases) page, extract it, and drag CanvasBar into your Applications folder.

If you want to build it yourself, clone the repo and open `CanvasBar.xcodeproj` in Xcode.

## Setup

1. Launch CanvasBar — it will appear in your menu bar
2. Grab your Canvas ICS feed URL — in Canvas, go to Calendar and look for "Calendar Feed" in the bottom left, then copy the link
3. Paste the URL into CanvasBar when prompted

## Usage

Click the menu bar icon to see your assignments. Check things off as you finish them, add notes if needed, and toggle launch-at-login from the bottom of the popover.

## Tech Stack

- SwiftUI
- Custom ICS parser with line unfolding and date handling
- UserDefaults for persistent state

## Author

Adi Kasar — [github.com/adikasar3](https://github.com/adikasar3)
