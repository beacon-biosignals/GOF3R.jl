module GOF3R

using s3gof3r_jll


function s3stream(bucket, path)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        return open(`$exe get -b $(bucket) -k $(path) --endpoint=$(endpoint)`)
    end
end

function s3getfile(bucket, path, outfile)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        open(`$exe get -b $(bucket) -k $(path) --endpoint=$(endpoint)`) do io
            write(outfile, io)
        end
    end

end

function s3upload(bucket, file, key)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        run(`$exe cp $(file) s3://$(bucket)/$(key) --endpoint=$(endpoint)`)
    end
end

function version()
    s3gof3r_jll.gof3r() do exe
        run(`$exe --version`)
    end
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


const AWS_ENDPOINT = Ref{String}("")

function __init__()
    # make sure we have a region set
    if !haskey(ENV, "AWS_REGION")
        ENV["AWS_REGION"] = "us-east-2"
    end
    AWS_ENDPOINT[] = get(ENV, "AWS_ENDPOINT", "s3.us-east-2.amazonaws.com")
end


end # module
