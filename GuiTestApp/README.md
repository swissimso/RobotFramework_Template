# GUI Test Playground

A small deterministic Windows Forms application intended as a target for automated GUI tests.

## Fastest way to run it

1. Extract this folder on a Windows PC.
2. Double-click `run.bat`.
3. On the first run, `build.bat` uses the Windows .NET Framework C# compiler to create `GuiTestApp.exe`.
4. Later runs launch the existing EXE directly.

No Visual Studio project and no PowerShell execution-policy change is required for the normal build path.

`build.ps1` is included as an alternative build method.

## Stable control names / automation targets

| Control | Name | Initial / useful values |
|---|---|---|
| Main window | `MainWindow` | Title: `GUI Test Playground` |
| Input box | `InputText` | empty |
| Input character count | `InputCountLabel` | `Characters: 0` |
| Output box | `OutputText` | empty, read-only |
| Echo radio | `ModeEcho` | checked |
| Reverse radio | `ModeReverse` | unchecked |
| Repeat radio | `ModeRepeat` | unchecked |
| Selected mode label | `SelectionLabel` | `Selected mode: Echo` |
| Uppercase checkbox | `UppercaseCheckBox` | unchecked |
| Brackets checkbox | `BracketsCheckBox` | unchecked |
| Options label | `OptionsLabel` | `Options: none` |
| Process button | `ProcessButton` | `Process` |
| Clear button | `ClearButton` | `Clear text` |
| Counter button | `CounterButton` | `Increment counter` |
| State button | `StateButton` | `State: OFF` |
| Reset button | `ResetButton` | `Reset all` |
| Counter label | `CounterValueLabel` | `Counter: 0` |
| State label | `StateIndicatorLabel` | `State indicator: OFF` |
| Last action label | `LastActionLabel` | `Last action: Reset` |
| Status label | `StatusLabel` | `Ready` |

The controls also have `AccessibleName` values to make UI Automation inspection easier.

## Deterministic behaviors to assert

### Typing
Typing `hello` into `InputText` changes:

- `InputCountLabel` -> `Characters: 5`
- `StatusLabel` -> `Input changed`
- `LastActionLabel` -> `Last action: Input changed`

### Process: Echo
Input `hello`, leave `ModeEcho` selected, click `ProcessButton`:

- `OutputText` -> `hello`
- `StatusLabel` -> `Processed successfully`
- `ProcessButton` text -> `Processed!`

### Process: Reverse
Input `hello`, select `ModeReverse`, click Process:

- `OutputText` -> `olleh`

### Process: Repeat
Input `hello`, select `ModeRepeat`, click Process:

- `OutputText` -> `hello | hello`

### Modifier checkboxes
Input `hello`, select `UppercaseCheckBox` and `BracketsCheckBox`, click Process:

- `OutputText` -> `[HELLO]`
- `OptionsLabel` -> `Options: UPPERCASE + brackets`

### Validation
Leave input empty and click Process:

- `OutputText` -> `ERROR: Input is empty`
- `StatusLabel` -> `Validation failed`
- `ProcessButton` text -> `Try again`

### Counter
Click `CounterButton` three times:

- `CounterValueLabel` -> `Counter: 3`
- `CounterButton` text -> `Increment counter (3)`
- `StatusLabel` -> `Counter incremented to 3`

### State toggle
Click `StateButton` once:

- Button -> `State: ON`
- `StateIndicatorLabel` -> `State indicator: ON`
- `StatusLabel` -> `State changed to ON`

Click it again and all three return to `OFF` state.

### Reset
After changing anything, click `ResetButton`:

- input/output become empty
- Echo is selected
- both checkboxes are cleared
- counter returns to 0
- state returns to OFF
- `StatusLabel` -> `Ready`
- `LastActionLabel` -> `Last action: Reset`

## Why this is useful for GUI automation

The application intentionally avoids animations, network access, random values, timestamps, delayed state changes, and other nondeterministic behavior. Each interaction immediately changes one or more visible controls, providing straightforward assertion targets.
