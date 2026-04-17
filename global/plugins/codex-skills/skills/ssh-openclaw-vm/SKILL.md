---
name: ssh-openclaw-vm
description: >
  Use when the user asks to "ssh vao vm", "ssh vào vm", "ssh vao 2 vm", "ssh vào 2 vm",
  "vao linux vm", "vao mac vm", "ket noi vm", "connect vm", "ssh openclaw vm",
  "ssh vao server", "ssh vào server", "server thue", "server thuê", "chiasegpu",
  "backup-blackbird", or wants Codex to connect from the host to the OpenClaw VMs
  or standby server endpoints without relying on stale raw IP assumptions.
---


# SSH OpenClaw VM

Skill nay dung cho viec SSH tu host macOS vao cac may van hanh trong he OpenClaw.

## Nguon doi chieu phai doc

- `/Users/nguyenquocthong/.ssh/config`
- `/Users/nguyenquocthong/.ssh/known_hosts`
- `/Users/nguyenquocthong/project/openclaw/docs/operations/ssh-vm-guide.md`
- `/Users/nguyenquocthong/project/openclaw/docs/operations/ssh-targets.md`
- `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/README.md`
- `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/AUTOMATION.md`

## Topology truth

- `linuxvm` la primary runtime da verify cua platform.
- `macvm` la Mac VM noi bo, khong phai cloud standby.
- `chiasegpu-vm` la route legacy/recovery cho may thue cu:
  - `ssh chiasegpu-vm`
  - `e1.chiasegpu.vn:55463`
  - guest hostname lich su: `blackbirdvmchiasegpu`
- `backup-blackbird` la logical standby node trong deploy-platform.
- `backup-blackbird` khong duoc dong nhat tu dong voi `chiasegpu-vm`.
- Neu tai lieu nhac `e1.chiasegpu.vn:44518`, xem do la standby endpoint can verify live, khong phai chan ly bat bien.

## Nguyen tac bat buoc

1. Khong gom `linuxvm`, `chiasegpu-vm`, va `backup-blackbird` thanh cung mot may chi vi cung lien quan toi `e1.chiasegpu.vn` hoac ChiaseGPU.
2. Khong gia dinh port `22`, `44518`, va `55463` tren cung hostname la cung mot SSH identity.
3. Phai verify theo tung route:
   - TCP connect
   - SSH banner
   - auth/login
   - hostname trong guest
4. Neu route accept TCP nhung khong tra `SSH-2.0-...`, day la broken/stale endpoint. Khong bao cao sai thanh auth failure.
5. Neu host fingerprint hien tai khong khop voi fingerprint lich su, phai goi dung ten: `fingerprint drift` hoac `route drift`.
6. Khi user noi "ssh vao server", phai lam ro ho muon:
   - primary runtime -> `linuxvm`
   - standby node -> doi chieu deploy-platform docs va route standby hien tai
   - legacy rented server -> `chiasegpu-vm`

## Default route chon may

1. Neu user noi chung chung "ssh vao vm":
   - `ssh linuxvm`
   - `ssh macvm`
2. Neu user noi "linux vm":
   - `ssh linuxvm`
3. Neu user noi "mac vm":
   - `ssh macvm`
4. Neu user noi "server thue" hoac "chiasegpu-vm":
   - `ssh chiasegpu-vm`
5. Neu user noi "backup-blackbird", "standby", "node du phong", hoac dang debug deploy-platform standby:
   - doc them deploy-platform docs
   - dung route standby dang duoc khai bao o runtime/docs
   - verify route do truoc khi bao la dung may

## Lenh verify toi thieu

Mac/Linux VM:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=5 linuxvm 'hostname && whoami && pwd'
ssh -o BatchMode=yes -o ConnectTimeout=5 macvm 'hostname && whoami && pwd'
```

Legacy rented server:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=5 chiasegpu-vm 'hostname && whoami && pwd'
```

Standby endpoint raw can verify theo 3 lop:

```bash
nc -vz -G 5 e1.chiasegpu.vn 44518
python3 - <<'PY'
import socket
s = socket.socket()
s.settimeout(10)
s.connect(("e1.chiasegpu.vn", 44518))
try:
    print(repr(s.recv(128)))
finally:
    s.close()
PY
ssh -o BatchMode=yes -o ConnectTimeout=10 -p 44518 ubuntu@e1.chiasegpu.vn 'hostname && whoami && pwd'
```

## Cach dien giai ket qua

- TCP ok + co SSH banner + vao shell duoc:
  route SSH song, bao cao hostname that.
- TCP ok + khong co SSH banner:
  endpoint dang treo truoc SSH handshake; khong phai loi password.
- Co SSH banner + auth fail:
  route dung, nhung credential sai hoac drift.
- Fingerprint khac tai lieu cu:
  host/route da doi identity; can verify lai truoc khi tiep tuc.

## Lenh van hanh can uu tien tren primary

Neu user dang kiem tra production runtime, uu tien:

```bash
ssh linuxvm '~/bin/prod-audit'
ssh linuxvm '~/bin/prod-reboot-check'
```

`prod-audit` la truth command cua primary runtime.

## Output ky vong

Sau moi lan thuc hien, phai noi ro:

- route nao da thu
- may nao da vao duoc
- hostname xac nhan
- route nao chi moi qua TCP
- route nao vo o banner, auth, hay host-key mismatch
- neu co drift, noi ro drift giua `linuxvm`, `chiasegpu-vm`, va `backup-blackbird`
