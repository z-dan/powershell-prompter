# powershell-prompter
A custom powershell prompt function that replaces the default powershell prompt, abbreviating long directory names while still showing the salient information from the directory path.

This prompt will show the current directory location. When the 
directory name exceeds the configured maximum length the middle of
the directory name is replaced with a configured replacement string
(e.g. the eplisis " ... ").

For example, when in the following directory:
 `C:\Users\Name\Documents\Adobe\Premiere Elements\4.0\Adobe Premiere Elements Auto-Save`
 
the prompt appears as:
 
 `# ~\Documents ... ements\4.0\Adobe Premiere Elements Auto-Save>`

To modify the configured values modify the variables:
```powershell
$maxPromptPathLength
$inter
$promptColour
```
at the start of the script.

To use the prompt, dot source this script:
. .\prompt.ps1

or copy it's contents into your powershell profile.
See
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
