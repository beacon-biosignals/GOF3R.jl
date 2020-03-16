module GOF3R
using Pkg.Artifacts

if Sys.islinux()
    const gof3r_exe = joinpath(artifact"s3gof3r", "gof3r_0.5.0_linux_amd64", "gof3r")
elseif Sys.iswindows()
    const gof3r_exe = joinpath(artifact"s3gof3r", "gof3r.exe")
else #macos
    const gof3r_exe = joinpath(artifact"s3gof3r", "gof3r_0.5.0_darwin_amd64", "gof3r")
end

end # module
