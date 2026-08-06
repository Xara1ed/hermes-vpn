#!/usr/bin/env python3
"""
Simple Telegram MTProto Proxy - Railway Compatible
"""
import asyncio
import os
import struct

PORT = int(os.environ.get('PORT', 8080))
SECRET = os.environ.get('PROXY_SECRET', 'ee1234567890abcdef1234567890ab')

# Telegram DC IPs
DC_IPS = {
    1: '149.154.175.50',
    2: '149.154.167.51', 
    3: '149.154.175.100',
    4: '149.154.167.91',
    5: '91.108.56.130',
}

async def forward(reader, writer):
    try:
        while True:
            data = await reader.read(8192)
            if not data:
                break
            writer.write(data)
            await writer.drain()
    except:
        pass

async def handle_client(reader, writer):
    try:
        data = await reader.read(64)
        if not data:
            writer.close()
            return
            
        # تشخیص DC
        dc_id = 2
        if len(data) > 60:
            dc_id = (data[57] + data[58]) % 4 + 1
            
        ip = DC_IPS.get(dc_id, DC_IPS[2])
        
        remote_reader, remote_writer = await asyncio.open_connection(ip, 443)
        
        await asyncio.gather(
            forward(reader, remote_writer),
            forward(remote_reader, writer)
        )
    except Exception as e:
        print(f"Error: {e}")
    finally:
        writer.close()

async def main():
    server = await asyncio.start_server(handle_client, '0.0.0.0', PORT)
    print(f"[*] MTProto Proxy on port {PORT}")
    secret_hex = SECRET.encode().hex()
    print(f"[*] Link: tg://proxy?server=hermes-vpn-production.up.railway.app&port={PORT}&secret={secret_hex}")
    async with server:
        await server.serve_forever()

if __name__ == '__main__':
    asyncio.run(main())
