#$s = ".cp"

function extensionCodecCheck() {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$extensionType
    )
    $codec=@{
        user = ".u"
        system = ".s"
        combo = ".cb"
        comboWithGroup = ".cbg"
    }
    $codecKeys = $codec.Keys

    # For each key in codec
    foreach ($key in $codecKeys){
        $value = $codec[$key]
        if ($extensionType -eq $value){
            #Write-Host "$extensionType : $key"
            $found = $key
        }
    }
    Return $found # Key of Extension $null means not found
}
#extensionCodecCheck -extensionType $s

function isExt(){
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$extensionType
    )
    $codec=@{
        user = ".u"
        system = ".s"
        combo = ".cb"
        comboWithGroup = ".cbg"
    }
    $value = $null

    $value = $codec.ContainsValue($extensionType)
    Return $value # Booleon if Extension Exists
}
#isExt -extensionType $s

function listValues{
    $codec=@{
        user = ".u"
        system = ".s"
        combo = ".cb"
        comboWithGroup = ".cbg"
    }

    $list = New-Object System.Collections.ArrayList($codec.Keys)
    Return $list # List all Values/Extensions
}
#listValues

function checkFormat{
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$extensionType
    )
    $codec=@{
        user = ".u"
        system = ".s"
        combo = ".cb"
        comboWithGroup = ".cbg"
    }
    $codecFormat=@{
        user="User"
        system="System"
        combo="System;User"
        comboWithGroup="System;User;Group"
    }
    $type = extensionCodecCheck -extensionType $extensionType
    if ([string]::IsNullOrEmpty($type)){
        $value = $false
    }else{
        $value = $codecFormat.ContainsKey($type)
        if ([string]::IsNullOrEmpty($value)){
            $value = $false
        }
    }

    Return $value
}
#checkFormat -extensionType $s

function getFormat{
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$extensionType
    )
    $codec=@{
        user = ".u"
        system = ".s"
        combo = ".cb"
        comboWithGroup = ".cbg"
    }
    $codecFormat=@{
        user="User"
        system="System"
        combo="System;User"
        comboWithGroup="System;User;Group"
    }
    $type = extensionCodecCheck -extensionType $extensionType
    $format = $codecFormat[$type]
    Return $format
}
#getFormat -extensionType $s

function testConn{
    $value = $true

    Return $value
}