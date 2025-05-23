import struct
import glob

def is_moov_at_start(file_path):
    with open(file_path, 'rb') as f:
        # 读取前 8 字节（原子头部：4字节大小 + 4字节类型）
        data = f.read(8)
        if len(data) < 8:
            return False

        # 解析原子大小和类型
        atom_size = struct.unpack('>I', data[:4])[0]  # 大端序
        atom_type = data[4:8].decode('ascii')

        # 检查是否是 'moov'
        if atom_type == 'moov':
            return True

        # 如果不是，检查是否是 'ftyp'（MP4 文件通常以 ftyp 开头）
        if atom_type == 'ftyp':
            # 跳过 ftyp，检查下一个原子
            f.seek(atom_size - 8, 1)  # 从当前位置偏移
            next_data = f.read(8)
            if len(next_data) < 8:
                return False
            next_atom_type = next_data[4:8].decode('ascii')
            return next_atom_type == 'moov'

    return False

if __name__ == '__main__':
    mp4_files = glob.glob('*.mp4')
    for file in mp4_files:
        print(f'{file}: {is_moov_at_start(file)}')  # True 表示 moov 前置

# if False, run:
#   ffmpeg -i input.mp4 -movflags faststart -c copy output.mp4
