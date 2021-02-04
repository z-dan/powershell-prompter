<#PSScriptInfo

.VERSION 1.0

.GUID 81105daa-8ccd-4936-8142-9733cee1d5fb

.AUTHOR Dan

.COPYRIGHT (c) 2020 Dan Zakaib

.TAGS

.LICENSEURI https://github.com/z-dan/powershell-prompter/blob/master/LICENSE


.RELEASENOTES



.DESCRIPTION 
A custom prompt function to shorten the displayed directory name. 

This prompt will show the current directory location. When the 
directory name exceeds the configured maximum length the middle of
the directory name is replaced with a configured replacement string
(e.g. the eplisis " ... ").

For example, when in the following directory:
 C:\Users\Name\Documents\Adobe\Premiere Elements\4.0\Adobe Premiere Elements Auto-Save"
 
the prompt appears as:
 
 # ~\Documents ... ements\4.0\Adobe Premiere Elements Auto-Save>

To modify the configured values modify the variables:
$maxPromptPathLength
$inter
$promptColour

at the start of the script.

To use the prompt, dot source this script:
. .\prompt.ps1

or copy it's contents into your powershell profile
See
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

#>

function prompt
{
	#configuration params
    
	# how long the prompt should be before it becomes shortened
	$maxPromptPathLength = 60
	# the middle part of the path is replaced with the string $inter
    $inter = " ... "
	# what colour you want the prompt to be
	$promptColour = "Magenta"

    $pth = $(Get-Location).ProviderPath
	
	
	#If we are in the local users profile, replace the beginning with "~"
	 
	if($pth -like "$($env:USERPROFILE)*")
	{
		$pth = $pth -replace [regex]::escape($env:USERPROFILE),"~"
	}
	
    #if the path is too long, then shorten it by replacing part of it with $inter
    if($pth.Length -gt ($maxPromptPathLength + $inter.Length))
    {
        #never chop off any of the leaf.
        $lf = $(split-path $pth -Leaf)
        $top = $pth
        $topTest = $(split-path $top)
        #never chop off any of the root directory.
        # determine root by splitting the path until we can't anymore.
        while($topTest.Length -gt 0)
        {
            $top =  $topTest
            $topTest = $(split-path $topTest)
        }
        # this condition protects against the case where you have a very long root or a very long leaf
        # and so we shouldn't bother chopping it up.
        if(($top.Length + $inter.Length + $lf.Length + 1) -lt $pth.Length)
        {
            $middleLength = $maxPromptPathLength - $lf.Length - $inter.Length - $top.Length
            if($middleLength -lt 0){$middleLength = 1}
            $middleFront = [int] ($middleLength/2)
            $middleBack = $middleLength - $middleFront
            $pth = $(join-path $($($pth.SubString(0,$middleFront+$top.Length))  + $inter + $($pth.SubString($pth.Length-$lf.Length-$middleBack,$middleBack))) $lf)
        }
    
    }
    #This comes from the default powershell prompt function.
    $prmpt = $(if (test-path variable:/PSDebugContext) 
            { 
                '[DBG]: ' 
            } else { 
            '' 
            }) + '# ' + $pth + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '>';
			
	Write-Host "$prmpt"  -nonewline -foregroundcolor $promptColour
	' '
}
