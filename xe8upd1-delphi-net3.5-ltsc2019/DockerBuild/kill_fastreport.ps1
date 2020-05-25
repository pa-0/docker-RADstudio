$code = {
    $killed = 0;
    while ($killed -eq 0) {
        $fastreport = Get-Process FastReport4VCL -ErrorAction SilentlyContinue;
        if ($fastreport) {
            # try gracefully first
            $fastreport.CloseMainWindow();
            # kill after five seconds
            Start-Sleep 5;
            if (!$fastreport.HasExited) {
                $fastreport | Stop-Process -Force;
            }
            $killed = 1;
        }
        Start-Sleep 1;
    }
}

$job = Start-Job -ScriptBlock $code;