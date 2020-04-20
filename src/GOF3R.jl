module GOF3R

using s3gof3r_jll

export s3stream, s3getfile, s3upload

"""
    s3stream(bucket, path)

Return an `IO` object streaming `path` from `bucket`.
"""
function s3stream(bucket, path)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        return open(`$exe get -b $(bucket) -k $(path) --endpoint=$(endpoint)`)
    end
end

"""
    s3getfile(bucket, path, outfile)

Write the file at `bucket:path` to `outfile`.
"""
function s3getfile(bucket, path, outfile)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        open(`$exe get -b $(bucket) -k $(path) --endpoint=$(endpoint)`) do io
            write(outfile, io)
        end
    end
end

"""
    s3upload(bucket, file, key)

Upload `file` to `bucket:key`.
"""
function s3upload(bucket, file, key)
    endpoint = AWS_ENDPOINT[]
    s3gof3r_jll.gof3r() do exe
        run(`$exe cp $(file) s3://$(bucket)/$(key) --endpoint=$(endpoint)`)
    end
end

"""
    s3stream(f, bucket, path)

Call `f(s3stream(bucket, path))`, ensuring that the stream is closed properly once `f`
has finished executing, including in the case of errors.
"""
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
    success(stream) || Base.pipeline_error(stream)
    return ret
end

const AWS_ENDPOINT = Ref{String}("")

function __init__()
    # make sure we have a region set
    if !haskey(ENV, "AWS_REGION")
        ENV["AWS_REGION"] = "us-east-2"
    end
    AWS_ENDPOINT[] = get(ENV, "AWS_ENDPOINT", "s3.$(ENV["AWS_REGION"]).amazonaws.com")
end

end # module
