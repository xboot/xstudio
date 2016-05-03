-- Copyright 2011-12 Paul Kulchenko, ZeroBrane LLC

local xboot
local win = ide.osname == "Windows"
local mac = ide.osname == "Macintosh"

return {
  name = "Xboot",
  description = "xboot runtime environment",
  api = {"baselib", "xboot"},
  frun = function(self,wfilename,rundebug)
    xboot = xboot or ide.config.path.xboot -- check if the path is configured
    if not xboot then
      local sep = win and ';' or ':'
      local default =
           win and (GenerateProgramFilesPath('love', sep)..sep)
        or mac and ('/Applications/love.app/Contents/MacOS'..sep)
        or ''
      local path = default
                 ..(os.getenv('PATH') or '')..sep
                 ..(GetPathWithSep(self:fworkdir(wfilename)))..sep
                 ..(os.getenv('HOME') and GetPathWithSep(os.getenv('HOME'))..'bin' or '')
      local paths = {}
      for p in path:gmatch("[^"..sep.."]+") do
        xboot = xboot or GetFullPathIfExists(p, win and 'love.exe' or 'love')
        table.insert(paths, p)
      end
      if not xboot then
        DisplayOutputLn("Can't find xboot executable in any of the following folders: "
          ..table.concat(paths, ", "))
        return
      end
    end

    if not GetFullPathIfExists(self:fworkdir(wfilename), 'main.lua') then
      DisplayOutputLn(("Can't find 'main.lua' file in the current project folder: '%s'.")
        :format(self:fworkdir(wfilename)))
      return
    end

    if rundebug then
      DebuggerAttachDefault({runstart = ide.config.debugger.runonstart == true})
    end

    -- suppress hiding ConsoleWindowClass as this is used by Love console
    local uhw = ide.config.unhidewindow
    local cwc = uhw and uhw.ConsoleWindowClass
    if uhw then uhw.ConsoleWindowClass = 0 end

    local params = ide.config.arg.any or ide.config.arg.xboot
    local cmd = ('"%s" "%s"%s%s'):format(xboot, self:fworkdir(wfilename),
      params and " "..params or "", rundebug and ' -debug' or '')
    -- CommandLineRun(cmd,wdir,tooutput,nohide,stringcallback,uid,endcallback)
    return CommandLineRun(cmd,self:fworkdir(wfilename),true,true,nil,nil,
      function() if uhw then uhw.ConsoleWindowClass = cwc end end)
  end,
  hasdebugger = true,
  fattachdebug = function(self) DebuggerAttachDefault() end,
  scratchextloop = true,
  takeparameters = true,
}
