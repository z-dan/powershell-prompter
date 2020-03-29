<#PSScriptInfo

.VERSION 1.0

.GUID 81105daa-8ccd-4936-8142-9733cee1d5fb

.AUTHOR Dan

.COMPANYNAME

.COPYRIGHT (c) 2020 dan Zakaib

.TAGS

.LICENSEURI https://github.com/z-dan/powershell-prompter/blob/master/LICENSE

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 A custom prompt function to shorten the displayed directory name. 

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
