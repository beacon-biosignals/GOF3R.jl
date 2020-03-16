module GOF3R
using Pkg.Artifacts

if Sys.islinux()
    const gof3r = joinpath(artifact"s3gof3r", "gof3r_0.5.0_linux_amd64", "gof3r")
elseif Sys.iswindows()
    const gof3r = joinpath(artifact"s3gof3r", "gof3r.exe")
else #macos
    const gof3r = joinpath(artifact"s3gof3r", "gof3r_0.5.0_darwin_amd64", "gof3r")
end

function s3stream(bucket, path)
    endpoint = "s3.us-east-2.amazonaws.com"
    return open(`$gof3r get -b $(bucket) -k $(path) --endpoint=$(endpoint)`)
end

function s3getfile(bucket, path, outfile)
    endpoint = "s3.us-east-2.amazonaws.com"
    open(`$gof3r get -b $(bucket) -k $(path) --endpoint=$(endpoint)`) do io
        write(outfile, io)
    end
end

function s3upload(bucket, file, key)
    ENV["AWS_REGION"] = "us-east-2"
    endpoint = "s3.us-east-2.amazonaws.com"
    run(`$gof3r cp $(file) s3://$(bucket)/$(key) --endpoint=$(endpoint)`)
end

function s3stream(f, bucket, path)
    stream = s3stream(bucket, path)
    ret = try
        f(stream)
    catch
        kill(stream)
        rethrow()
    finally
        close(stream.in)
    end
    success(stream) || pipeline_error(stream)
    return ret
end


end # module
