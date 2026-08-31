using System;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace GuiTestApp
{
    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }

    public sealed class MainForm : Form
    {
        private TextBox inputText;
        private TextBox outputText;
        private Label inputCountLabel;
        private Label statusLabel;
        private Label lastActionLabel;
        private Label selectionLabel;
        private Label optionsLabel;
        private Label counterValueLabel;
        private Label stateIndicatorLabel;

        private RadioButton modeEcho;
        private RadioButton modeReverse;
        private RadioButton modeRepeat;

        private CheckBox uppercaseCheckBox;
        private CheckBox bracketsCheckBox;

        private Button processButton;
        private Button clearButton;
        private Button counterButton;
        private Button stateButton;
        private Button resetButton;

        private int counter = 0;
        private bool stateOn = false;

        public MainForm()
        {
            InitializeForm();
            BuildUi();
            WireEvents();
            ResetApplicationState();
        }

        private void InitializeForm()
        {
            Text = "GUI Test Playground";
            Name = "MainWindow";
            AccessibleName = "GUI Test Playground Main Window";
            AccessibleDescription = "Deterministic Windows Forms application for automated GUI testing.";
            StartPosition = FormStartPosition.CenterScreen;
            ClientSize = new Size(820, 620);
            MinimumSize = new Size(760, 580);
            Font = new Font("Segoe UI", 10F, FontStyle.Regular, GraphicsUnit.Point);
            AutoScaleMode = AutoScaleMode.Dpi;
        }

        private void BuildUi()
        {
            var root = new TableLayoutPanel();
            root.Name = "RootLayout";
            root.Dock = DockStyle.Fill;
            root.Padding = new Padding(16);
            root.ColumnCount = 1;
            root.RowCount = 6;
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 56));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 118));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 138));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 118));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 70));
            root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
            Controls.Add(root);

            var headingPanel = new Panel { Dock = DockStyle.Fill };
            var heading = new Label
            {
                Name = "TitleLabel",
                AccessibleName = "Title",
                Text = "GUI Test Playground",
                AutoSize = true,
                Font = new Font(Font.FontFamily, 18F, FontStyle.Bold),
                Location = new Point(0, 0)
            };
            var subtitle = new Label
            {
                Name = "SubtitleLabel",
                AccessibleName = "Subtitle",
                Text = "A deliberately predictable target for GUI automation.",
                AutoSize = true,
                ForeColor = SystemColors.GrayText,
                Location = new Point(2, 34)
            };
            headingPanel.Controls.Add(heading);
            headingPanel.Controls.Add(subtitle);
            root.Controls.Add(headingPanel, 0, 0);

            var textGroup = new GroupBox
            {
                Name = "TextGroup",
                AccessibleName = "Text Input and Output Group",
                Text = "Text",
                Dock = DockStyle.Fill,
                Padding = new Padding(10)
            };
            root.Controls.Add(textGroup, 0, 1);

            var textLayout = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                ColumnCount = 2,
                RowCount = 2
            };
            textLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            textLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            textLayout.RowStyles.Add(new RowStyle(SizeType.Absolute, 26));
            textLayout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
            textGroup.Controls.Add(textLayout);

            var inputLabel = new Label
            {
                Text = "Input",
                Name = "InputLabel",
                AccessibleName = "Input Label",
                AutoSize = true,
                Anchor = AnchorStyles.Left
            };
            inputCountLabel = new Label
            {
                Text = "Characters: 0",
                Name = "InputCountLabel",
                AutoSize = true,
                Anchor = AnchorStyles.Right
            };

            var inputHeader = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 2, RowCount = 1 };
            inputHeader.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            inputHeader.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            inputHeader.Controls.Add(inputLabel, 0, 0);
            inputHeader.Controls.Add(inputCountLabel, 1, 0);
            textLayout.Controls.Add(inputHeader, 0, 0);

            var outputLabel = new Label
            {
                Text = "Output",
                Name = "OutputLabel",
                AccessibleName = "Output Label",
                AutoSize = true,
                Anchor = AnchorStyles.Left
            };
            textLayout.Controls.Add(outputLabel, 1, 0);

            inputText = new TextBox
            {
                Name = "InputText",
                AccessibleName = "Input Text",
                AccessibleDescription = "Text to be processed.",
                Multiline = true,
                Dock = DockStyle.Fill,
                ScrollBars = ScrollBars.Vertical,
                TabIndex = 0
            };
            outputText = new TextBox
            {
                Name = "OutputText",
                AccessibleName = "Output Text",
                AccessibleDescription = "Read only processing result.",
                Multiline = true,
                ReadOnly = true,
                Dock = DockStyle.Fill,
                ScrollBars = ScrollBars.Vertical,
                BackColor = SystemColors.Window,
                TabIndex = 1
            };
            textLayout.Controls.Add(inputText, 0, 1);
            textLayout.Controls.Add(outputText, 1, 1);

            var choicesLayout = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                ColumnCount = 2,
                RowCount = 1
            };
            choicesLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            choicesLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            root.Controls.Add(choicesLayout, 0, 2);

            var radioGroup = new GroupBox
            {
                Name = "ModeGroup",
                AccessibleName = "Processing Mode Group",
                Text = "Radio buttons — processing mode",
                Dock = DockStyle.Fill,
                Padding = new Padding(12)
            };
            choicesLayout.Controls.Add(radioGroup, 0, 0);

            var radioFlow = new FlowLayoutPanel
            {
                Dock = DockStyle.Fill,
                FlowDirection = FlowDirection.TopDown,
                WrapContents = false
            };
            radioGroup.Controls.Add(radioFlow);

            modeEcho = NewRadio("ModeEcho", "Echo", 2);
            modeReverse = NewRadio("ModeReverse", "Reverse", 3);
            modeRepeat = NewRadio("ModeRepeat", "Repeat ×2", 4);
            selectionLabel = NewStateLabel("SelectionLabel", "Selected mode: Echo");
            radioFlow.Controls.Add(modeEcho);
            radioFlow.Controls.Add(modeReverse);
            radioFlow.Controls.Add(modeRepeat);
            radioFlow.Controls.Add(selectionLabel);

            var checkGroup = new GroupBox
            {
                Name = "OptionsGroup",
                AccessibleName = "Options Group",
                Text = "Checkboxes — modifiers",
                Dock = DockStyle.Fill,
                Padding = new Padding(12)
            };
            choicesLayout.Controls.Add(checkGroup, 1, 0);

            var checkFlow = new FlowLayoutPanel
            {
                Dock = DockStyle.Fill,
                FlowDirection = FlowDirection.TopDown,
                WrapContents = false
            };
            checkGroup.Controls.Add(checkFlow);

            uppercaseCheckBox = NewCheckBox("UppercaseCheckBox", "Convert to UPPERCASE", 5);
            bracketsCheckBox = NewCheckBox("BracketsCheckBox", "Wrap output in [brackets]", 6);
            optionsLabel = NewStateLabel("OptionsLabel", "Options: none");
            checkFlow.Controls.Add(uppercaseCheckBox);
            checkFlow.Controls.Add(bracketsCheckBox);
            checkFlow.Controls.Add(optionsLabel);

            var actionGroup = new GroupBox
            {
                Name = "ActionsGroup",
                AccessibleName = "Actions Group",
                Text = "Buttons",
                Dock = DockStyle.Fill,
                Padding = new Padding(10)
            };
            root.Controls.Add(actionGroup, 0, 3);

            var buttonFlow = new FlowLayoutPanel
            {
                Dock = DockStyle.Fill,
                FlowDirection = FlowDirection.LeftToRight,
                WrapContents = true,
                AutoScroll = false
            };
            actionGroup.Controls.Add(buttonFlow);

            processButton = NewButton("ProcessButton", "Process", 7, 130);
            clearButton = NewButton("ClearButton", "Clear text", 8, 130);
            counterButton = NewButton("CounterButton", "Increment counter", 9, 150);
            stateButton = NewButton("StateButton", "State: OFF", 10, 130);
            resetButton = NewButton("ResetButton", "Reset all", 11, 130);

            buttonFlow.Controls.Add(processButton);
            buttonFlow.Controls.Add(clearButton);
            buttonFlow.Controls.Add(counterButton);
            buttonFlow.Controls.Add(stateButton);
            buttonFlow.Controls.Add(resetButton);

            var liveGroup = new GroupBox
            {
                Name = "LiveStateGroup",
                AccessibleName = "Live State Group",
                Text = "Live state — useful assertion targets",
                Dock = DockStyle.Fill,
                Padding = new Padding(10)
            };
            root.Controls.Add(liveGroup, 0, 4);

            var liveLayout = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                ColumnCount = 3,
                RowCount = 1
            };
            liveLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 34));
            liveLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33));
            liveLayout.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33));
            liveGroup.Controls.Add(liveLayout);

            counterValueLabel = NewStateLabel("CounterValueLabel", "Counter: 0");
            stateIndicatorLabel = NewStateLabel("StateIndicatorLabel", "State indicator: OFF");
            lastActionLabel = NewStateLabel("LastActionLabel", "Last action: Reset");
            liveLayout.Controls.Add(counterValueLabel, 0, 0);
            liveLayout.Controls.Add(stateIndicatorLabel, 1, 0);
            liveLayout.Controls.Add(lastActionLabel, 2, 0);

            var statusPanel = new Panel
            {
                Name = "StatusPanel",
                AccessibleName = "Status Panel",
                Dock = DockStyle.Fill,
                BorderStyle = BorderStyle.FixedSingle,
                Padding = new Padding(12)
            };
            root.Controls.Add(statusPanel, 0, 5);

            var statusTitle = new Label
            {
                Name = "StatusTitleLabel",
                AccessibleName = "Status Title",
                Text = "Status",
                AutoSize = true,
                Font = new Font(Font.FontFamily, 10F, FontStyle.Bold),
                Location = new Point(12, 12)
            };
            statusLabel = new Label
            {
                Name = "StatusLabel",
                AccessibleDescription = "Changes after every user action and is intended for GUI test assertions.",
                Text = "Ready",
                AutoSize = true,
                Location = new Point(12, 40),
                Font = new Font(Font.FontFamily, 12F, FontStyle.Regular)
            };
            statusPanel.Controls.Add(statusTitle);
            statusPanel.Controls.Add(statusLabel);

            AcceptButton = processButton;
        }

        private RadioButton NewRadio(string name, string text, int tabIndex)
        {
            return new RadioButton
            {
                Name = name,
                AccessibleName = text,
                Text = text,
                AutoSize = true,
                TabIndex = tabIndex,
                Margin = new Padding(3, 3, 3, 4)
            };
        }

        private CheckBox NewCheckBox(string name, string text, int tabIndex)
        {
            return new CheckBox
            {
                Name = name,
                AccessibleName = text,
                Text = text,
                AutoSize = true,
                TabIndex = tabIndex,
                Margin = new Padding(3, 3, 3, 5)
            };
        }

        private Button NewButton(string name, string text, int tabIndex, int width)
        {
            return new Button
            {
                Name = name,
                AccessibleName = text,
                Text = text,
                Width = width,
                Height = 42,
                TabIndex = tabIndex,
                Margin = new Padding(5)
            };
        }

        private Label NewStateLabel(string name, string text)
        {
            return new Label
            {
                Name = name,
                Text = text,
                AutoSize = true,
                Margin = new Padding(3, 6, 3, 3),
                Anchor = AnchorStyles.Left
            };
        }

        private void WireEvents()
        {
            inputText.TextChanged += delegate
            {
                inputCountLabel.Text = "Characters: " + inputText.Text.Length;
                SetLastAction("Input changed");
                statusLabel.Text = "Input changed";
                processButton.Text = "Process";
                processButton.AccessibleName = "Process";
            };

            modeEcho.CheckedChanged += ModeChanged;
            modeReverse.CheckedChanged += ModeChanged;
            modeRepeat.CheckedChanged += ModeChanged;

            uppercaseCheckBox.CheckedChanged += OptionsChanged;
            bracketsCheckBox.CheckedChanged += OptionsChanged;

            processButton.Click += delegate { ProcessInput(); };
            clearButton.Click += delegate { ClearText(); };
            counterButton.Click += delegate { IncrementCounter(); };
            stateButton.Click += delegate { ToggleState(); };
            resetButton.Click += delegate { ResetApplicationState(); };
        }

        private void ModeChanged(object sender, EventArgs e)
        {
            RadioButton radio = sender as RadioButton;
            if (radio == null || !radio.Checked)
            {
                return;
            }

            selectionLabel.Text = "Selected mode: " + GetSelectedMode();
            SetLastAction("Mode changed");
            statusLabel.Text = "Mode changed to " + GetSelectedMode();
            processButton.Text = "Process";
            processButton.AccessibleName = "Process";
        }

        private void OptionsChanged(object sender, EventArgs e)
        {
            string options = GetOptionsText();
            optionsLabel.Text = "Options: " + options;
            SetLastAction("Options changed");
            statusLabel.Text = "Options changed: " + options;
            processButton.Text = "Process";
            processButton.AccessibleName = "Process";
        }

        private string GetSelectedMode()
        {
            if (modeReverse.Checked) return "Reverse";
            if (modeRepeat.Checked) return "Repeat x2";
            return "Echo";
        }

        private string GetOptionsText()
        {
            if (!uppercaseCheckBox.Checked && !bracketsCheckBox.Checked)
            {
                return "none";
            }

            var parts = new StringBuilder();
            if (uppercaseCheckBox.Checked)
            {
                parts.Append("UPPERCASE");
            }
            if (bracketsCheckBox.Checked)
            {
                if (parts.Length > 0) parts.Append(" + ");
                parts.Append("brackets");
            }
            return parts.ToString();
        }

        private void ProcessInput()
        {
            string value = inputText.Text;
            if (string.IsNullOrWhiteSpace(value))
            {
                outputText.Text = "ERROR: Input is empty";
                statusLabel.Text = "Validation failed";
                SetLastAction("Process failed");
                processButton.Text = "Try again";
                processButton.AccessibleName = "Try again";
                return;
            }

            string result;
            if (modeReverse.Checked)
            {
                result = new string(value.Reverse().ToArray());
            }
            else if (modeRepeat.Checked)
            {
                result = value + " | " + value;
            }
            else
            {
                result = value;
            }

            if (uppercaseCheckBox.Checked)
            {
                result = result.ToUpperInvariant();
            }
            if (bracketsCheckBox.Checked)
            {
                result = "[" + result + "]";
            }

            outputText.Text = result;
            statusLabel.Text = "Processed successfully";
            SetLastAction("Process");
            processButton.Text = "Processed!";
            processButton.AccessibleName = "Processed";
        }

        private void ClearText()
        {
            inputText.Clear();
            outputText.Clear();
            statusLabel.Text = "Text cleared";
            SetLastAction("Clear text");
            processButton.Text = "Process";
            processButton.AccessibleName = "Process";
            inputText.Focus();
        }

        private void IncrementCounter()
        {
            counter++;
            counterValueLabel.Text = "Counter: " + counter;
            counterButton.Text = "Increment counter (" + counter + ")";
            counterButton.AccessibleName = "Increment counter " + counter;
            statusLabel.Text = "Counter incremented to " + counter;
            SetLastAction("Increment counter");
        }

        private void ToggleState()
        {
            stateOn = !stateOn;
            string value = stateOn ? "ON" : "OFF";
            stateButton.Text = "State: " + value;
            stateButton.AccessibleName = "State " + value;
            stateIndicatorLabel.Text = "State indicator: " + value;
            statusLabel.Text = "State changed to " + value;
            SetLastAction("Toggle state");
        }

        private void ResetApplicationState()
        {
            counter = 0;
            stateOn = false;

            inputText.Text = string.Empty;
            outputText.Text = string.Empty;
            modeEcho.Checked = true;
            modeReverse.Checked = false;
            modeRepeat.Checked = false;
            uppercaseCheckBox.Checked = false;
            bracketsCheckBox.Checked = false;

            inputCountLabel.Text = "Characters: 0";
            selectionLabel.Text = "Selected mode: Echo";
            optionsLabel.Text = "Options: none";
            counterValueLabel.Text = "Counter: 0";
            stateIndicatorLabel.Text = "State indicator: OFF";
            processButton.Text = "Process";
            processButton.AccessibleName = "Process";
            counterButton.Text = "Increment counter";
            counterButton.AccessibleName = "Increment counter";
            stateButton.Text = "State: OFF";
            stateButton.AccessibleName = "State OFF";
            lastActionLabel.Text = "Last action: Reset";
            statusLabel.Text = "Ready";
        }

        private void SetLastAction(string action)
        {
            lastActionLabel.Text = "Last action: " + action;
        }
    }
}
