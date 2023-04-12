" Starts a section for python3 code.
python3 << EOF
import vim

def read_file():
    """Reads the current buffer and returns a list of lines."""
    return vim.current.buffer[:]

def get_yaml_header(lines):
    """Returns the yaml header as a dictionary of properties."""
    if lines[0] != '---':
        return None
    yaml_header = {}
    start = False
    for i, line in enumerate(lines):
        if line == '---':
            if start:
                return yaml_header
            start = True
        elif start:
            key, value = line.split(':')
            yaml_header[key] = value.strip()
    return yaml_header

def get_code_blocks(lines):
    """Returns a list of code blocks."""
    code_blocks = {}
    start = False
    current_type = None
    for i, line in enumerate(lines):
        if line.startswith('```'):
            if not start:
                start = True
                current_type = line.replace('```', '')
                if not current_type in code_blocks:
                    code_blocks[current_type] = []
            else:
                start = False
                current_type = None
        elif start:
            code_blocks[current_type].append(line)
    return code_blocks

def write_code_blocks(code_blocks, yaml_header):
    """Writes the code blocks to the appropriate files."""

    path = vim.eval('expand("%:p:h")')
    filename = yaml_header.get('tangle')
    if not filename:
        print("No tangle header found.")
        return
    # Get the most appropriate code block.
    number_blocks = 0
    most_freq_code = None
    for code in code_blocks:
        if len(code_blocks[code]) > number_blocks:
            number_blocks = len(code_blocks[code])
            most_freq_code = code

    code = "\n".join(code_blocks[most_freq_code])
    print(f"Writing {filename} to {path}")
    with open(f"{path}/{filename}", 'w') as f:
        f.write(code)

def tangle():
    """Tangles the current buffer."""
    lines = read_file()
    yaml_header = get_yaml_header(lines)
    code_blocks = get_code_blocks(lines)
    write_code_blocks(code_blocks, yaml_header)

def tangleAdd(filename):
    """ Add a filename header if not exists. """
    lines = read_file()
    if lines[0] != '---':
        lines.insert(0, '---')
        lines.insert(1, 'tangle: ' + filename)
        lines.insert(2, '---')
    else:
        yaml_header = get_yaml_header(lines)
        if 'tangle' not in yaml_header:
            lines.insert(1, 'tangle: ' + filename)
        else:
            yaml_header['tangle'] = filename
            for i, line in enumerate(lines):
                if line.startswith('tangle:'):
                    lines[i] = 'tangle: ' + filename
                    continue
    vim.current.buffer[:] = lines
EOF


function! tangle#Tangle()
    python3 tangle()
endfunction

function! tangle#TangleAdd(filename)
    let filename = expand(a:filename)
    python3 tangleAdd(vim.eval('filename'))
endfunction


