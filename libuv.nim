## libuv bindings
##
## http://docs.libuv.org/en/v1.x/api.html

###########
# imports #
###########

when defined(windows):
  import winlean
else:
  import posix

#########
# types #
#########

type

  ##############################################################
  # buffer: http://docs.libuv.org/en/v1.x/misc.html#c.uv_buf_t #
  ##############################################################

  Buffer* {.pure, final, importc: "uv_buf_t", header: "uv.h"} = object
    ## http://docs.libuv.org/en/v1.x/misc.html#c.uv_buf_t.uv_buf_t.base
    base* {.importc: "base".}: cstring
    ## http://docs.libuv.org/en/v1.x/misc.html#c.uv_buf_t.uv_buf_t.len
    len* {.importc: "len".}: int

  PBuffer* = ptr Buffer

  ###################################################
  # check: http://docs.libuv.org/en/v1.x/check.html #
  ###################################################

  ## http://docs.libuv.org/en/v1.x/check.html#c.uv_check_t
  Check* {.pure, final, importc: "uv_check_t".} = object
    close_cb* {.importc: "close_cb".}: CloseProc
    data* {.importc: "data".}: pointer
    handle_queue* {.importc: "handle_queue".}: array[2, pointer]
    loop* {.importc: "loop".}: PLoop
    typ* {.importc: "type".}: HandleType

  PCheck* = ptr Check

  #####################################################################
  # connect: http://docs.libuv.org/en/v1.x/stream.html#c.uv_connect_t #
  #####################################################################

  ## http://docs.libuv.org/en/v1.x/stream.html#c.uv_connect_t
  Connect* {.pure, final, importc: "uv_connect_t", header: "uv.h"} = object
    active_queue* {.importc: "active_queue".}: array[2, pointer]
    cb* {.importc: "cb".}: ConnectProc
    data* {.importc: "data".}: pointer
    handle* {.importc: "handle".}: PStream
    reserved* {.importc: "reserved".}: array[4, pointer]
    typ* {.importc: "type".}: ReqType

  PConnect* = ptr Connect

  #####################################################
  # handle: http://docs.libuv.org/en/v1.x/handle.html #
  #####################################################

  ## http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_type
  HandleType* {.size: sizeof(cint).} = enum
    UNKNOWN_HANDLE = 0,
    FILE,
    HANDLE_TYPE_MAX

  ## http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_t
  Handle* {.inheritable, importc: "uv_handle_t", header: "uv.h".} = object
    close_cb* {.importc: "close_cb".}: CloseProc
    # http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_t.data
    data* {.importc: "data".}: pointer
    handle_queue* {.importc: "handle_queue".}: array[2, pointer]
    ## http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_t.loop
    loop* {.importc: "loop".}: PLoop
    ## http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_t.type
    typ* {.importc: "type".}: HandleType

  PHandle* = ptr Handle

  ## http://docs.libuv.org/en/v1.x/handle.html#c.uv_any_handle
  AnyHandle* {.pure, final, importc: "uv_any_handle".} = object {.union.}

  #####################################################
  # stream: http://docs.libuv.org/en/v1.x/stream.html #
  #####################################################

  ## http://docs.libuv.org/en/v1.x/stream.html#c.uv_stream_t
  Stream* {.inheritable, importc: "uv_stream_t", header: "uv.h".} = object of Handle
    alloc_cb* {.importc: "alloc_cb".}: AllocProc
    # close_cb* {.importc: "close_cb".}: CloseProc
    # data* {.importc: "data".}: pointer
    # handle_queue* {.importc: "handle_queue".}: array[2, pointer]
    # loop* {.importc: "loop".}: PLoop
    read_cb* {.importc: "read_cb".}: ReadProc
    # typ* {.importc: "type".}: HandleType
    write_queue_size* {.importc: "write_queue_size".}: int

  PStream* = ptr Stream

  #################################################
  # idle: http://docs.libuv.org/en/v1.x/idle.html #
  #################################################

  ## http://docs.libuv.org/en/v1.x/idle.html#c.uv_idle_t
  Idle* {.pure, final, importc: "uv_idle_t".} = object
    close_cb* {.importc: "close_cb".}: CloseProc
    data* {.importc: "data".}: pointer
    handle_queue* {.importc: "handle_queue".}: array[2, pointer]
    loop* {.importc: "loop".}: PLoop
    typ* {.importc: "type".}: HandleType

  PIdle* = ptr Idle

  #################################################
  # loop: http://docs.libuv.org/en/v1.x/loop.html #
  #################################################

  ## http://docs.libuv.org/en/v1.x/loop.html#c.uv_run_mode
  LoopMode* {.size: sizeof(cint).} = enum
    RUN_DEFAULT = 0,
    RUN_ONCE,
    RUN_NOWAIT

  ## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_configure
  LoopOption* {.size: sizeof(cint).} = enum
    LOOP_BLOCK_SIGNAL

  ## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_t
  Loop* {.pure, final, importc: "uv_loop_t", header: "uv.h".} = object
    active_handles* {.importc: "active_handles".}: cuint
    active_reqs* {.importc: "active_reqs".}: array[2, pointer]
    ## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_t.data
    data* {.importc: "data".}: pointer
    handle_queue* {.importc: "handle_queue".}: array[2, pointer]
    stop_flag* {.importc: "stop_flag".}: cuint

  PLoop* = ptr Loop

  #################################################
  # pipe: http://docs.libuv.org/en/v1.x/pipe.html #
  #################################################

  ## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_t
  Pipe* {.pure, final, importc: "uv_pipe_t", header: "uv.h".} = object of Stream
    ipc* {.importc: "ipc".}: cint

  PPipe* = ptr Pipe

  #######################################################
  # prepare: http://docs.libuv.org/en/v1.x/prepare.html #
  #######################################################

  ## http://docs.libuv.org/en/v1.x/prepare.html#c.uv_prepare_t
  Prepare* {.pure, final, importc: "uv_prepare_t".} = object of Handle

  PPrepare* = ptr Prepare

  #######################################################
  # process: http://docs.libuv.org/en/v1.x/process.html #
  #######################################################

  ## http://docs.libuv.org/en/v1.x/process.html#c.uv_process_flags
  ProcessFlag* {.size: sizeof(cint).} = enum
    PROCESS_SETUID = (1 shl 0),
    PROCESS_SETGID = (1 shl 1),
    PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 shl 2),
    PROCESS_DETACHED = (1 shl 3),
    PROCESS_WINDOWS_HIDE = (1 shl 4)

  ## http://docs.libuv.org/en/v1.x/process.html#c.uv_process_t
  Process* {.pure, final, importc: "uv_process_t", header: "uv.h".} = object
    exit_cb* {.importc: "exit_cb".}: ExitProc
    pid* {.importc: "pid".}: cint

  PProcess* = ptr Process

  ###################################################
  # req: http://docs.libuv.org/en/v1.x/request.html #
  ###################################################

  ## http://docs.libuv.org/en/v1.x/request.html#c.uv_req_t.type
  ReqType* {.size: sizeof(cint).} = enum
    UNKNOWN_REQ = 0,
    REQ_TYPE_PRIVATE,
    REQ_TYPE_MAX

  ## http://docs.libuv.org/en/v1.x/request.html#c.uv_req_t
  Req* {.pure, final, importc: "uv_req_t", header: "uv.h".} = object
    active_queue* {.importc: "active_queue".}: array[2, pointer]
    ## http://docs.libuv.org/en/v1.x/request.html#c.uv_req_t.data
    data* {.importc: "data".}: pointer
    reserved* {.importc: "reserved".}: array[4, pointer]
    ## http://docs.libuv.org/en/v1.x/request.html#c.uv_req_t.type
    typ* {.importc: "type".}: ReqType

  PReq* = ptr Req

  ## http://docs.libuv.org/en/v1.x/request.html#c.uv_any_req
  AnyReq* {.importc: "uv_any_req".} = object {.union.}

  #######################################################
  # shutdown: http://docs.libuv.org/en/v1.x/stream.html #
  #######################################################

  ## http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown_t
  Shutdown* {.pure, final, importc: "uv_shutdown_t", header: "uv.h".} = object
    active_queue* {.importc: "active_queue".}: array[2, pointer]
    cb* {.importc: "cb".}: ShutdownProc
    data* {.importc: "data".}: pointer
    handle* {.importc: "handle".}: PStream
    reserved* {.importc: "reserved".}: array[4, pointer]
    typ* {.importc: "type".}: ReqType

  PShutdown* = ptr Shutdown

  #####################################################
  # signal: http://docs.libuv.org/en/v1.x/signal.html #
  #####################################################

  ## http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_t
  Signal* {.pure, final, importc: "uv_signal_t".} = object of Handle
    signal_cb* {.importc: "signal_cb".}: SignalProc
    signum* {.importc: "signum".}: cint

  PSignal* = ptr Signal

  ###############################################
  # TCP: http://docs.libuv.org/en/v1.x/tcp.html #
  ###############################################

  TcpFlag* {.size: sizeof(cint).} = enum
    UV_TCP_IPV6ONLY = 1

  ## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_t
  Tcp* {.pure, final, importc: "uv_tcp_t".} = object of Stream

  PTcp* = ptr Tcp

  ###############################################
  # UDP: http://docs.libuv.org/en/v1.x/udp.html #
  ###############################################

  ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_membership
  UdpMembership* {.size: sizeof(cint).} = enum
    UV_LEAVE_GROUP = 0,
    UV_JOIN_GROUP

  ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_flags
  UdpFlag* {.size: sizeof(cint).} = enum
    UV_UDP_IPV6ONLY = 1,
    UV_UDP_PARTIAL = 2,
    UV_UDP_REUSEADDR = 4

  ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_t
  Udp* {.pure, final, importc: "uv_udp_t".} = object of Stream
    ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_t.send_queue_count
    send_queue_count* {.importc: "send_queue_count".}: int
    ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_t.send_queue_size
    send_queue_size* {.importc: "send_queue_size".}: int

  PUdp* = ptr Udp

  ## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_send_t
  UdpSend* {.pure, final, importc: "uv_udp_send_t".} = object
    active_queue* {.importc: "active_queue".}: array[2, pointer]
    cb* {.importc: "cb".}: UdpSendProc
    data* {.importc: "data".}: pointer
    handle* {.importc: "handle".}: PUdp
    reserved* {.importc: "reserved".}: array[4, pointer]
    typ* {.importc: "type".}: ReqType

  PUdpSend* = ptr UdpSend

  PSockAddr* = ptr SockAddr

  #####################################################
  ## write: http://docs.libuv.org/en/v1.x/stream.html #
  #####################################################

  ## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write_t
  Write* {.pure, final, importc: "uv_write_t", header: "uv.h".} = object
    active_queue* {.importc: "active_queue".}: array[2, pointer]
    cb* {.importc: "cb".}: WriteProc
    data* {.importc: "data".}: pointer
    handle* {.importc: "handle".}: PStream
    reserved* {.importc: "reserved".}: array[4, pointer]
    send_handle* {.importc: "send_handle".}: PStream
    typ* {.importc: "type".}: ReqType

  PWrite* = ptr Write

  ###################
  # procedure types #
  ###################

  # http://docs.libuv.org/en/v1.x/handle.html#c.uv_alloc_cb
  AllocProc* = proc (p: PHandle, i: int, buffer: PBuffer) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/check.html#c.uv_check_cb
  CheckProc* = proc (p: PCheck) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/handle.html#c.uv_close_cb
  CloseProc* = proc (p: PHandle) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_connect_cb
  ConnectProc* = proc (p: PConnect, status: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_connection_cb
  ConnectionProc* = proc (p: PStream, status: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/process.html#c.uv_exit_cb
  ExitProc* = proc (p: PProcess, exit_status: int64, term_signal: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/idle.html#c.uv_idle_cb
  IdleProc* = proc (p: PIdle) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/prepare.html#c.uv_prepare_cb
  PrepareProc* = proc (p: PPrepare) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_connection_cb
  PipeConnectionProc* = proc (p: PPipe, status: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_cb
  PipeReadProc* = proc (p: PPipe, nread: int, buffer: PBuffer) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_cb
  ReadProc* = proc (p: PStream, nread: int, buffer: PBuffer) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_cb
  SignalProc* = proc (p: PSignal, signum: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown_cb
  ShutdownProc* = proc (p: PShutdown, status: cint) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_recv_cb
  UdpRecvProc* = proc (p: PUdp, nread: int, buf: PBuffer, address: PSockAddr, flags: cuint)
  # http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_send_cb
  UdpSendProc* = proc (p: PUdpSend; status: cint)
  # http://docs.libuv.org/en/v1.x/loop.html#c.uv_walk_cb
  WalkProc* = proc (handle: PHandle, p: pointer) {.cdecl.}
  # http://docs.libuv.org/en/v1.x/stream.html#c.uv_write_cb
  WriteProc* = proc (p: PWrite, status: cint) {.cdecl.}

#########
# using #
#########

{.experimental.}

using
  # base...
  ci: cint
  cs, path: cstring
  flag: cuint
  i: int
  isf: int64
  p: pointer
  pci: ptr cint
  size: ptr int
  # loop...
  loop: PLoop
  mode: LoopMode
  option: LoopOption
  wp: WalkProc
  # stream...
  stream, stream2: PStream
  file: File
  address: PSockAddr
  sock: SocketHandle
  # handle...
  buffer: PBuffer
  handle: PHandle
  ht: HandleType
  req: PReq
  ap: AllocProc
  # check..
  check: PCheck
  chp: CheckProc
  # close...
  clp: CloseProc
  # connect...
  connect: PConnect
  cnp: ConnectionProc
  cp: ConnectProc
  # idle...
  idle: PIdle
  ip: IdleProc
  # prepare...
  pp: PrepareProc
  prepare: PPrepare
  # read...
  rp: ReadProc
  # shutdown...
  sd: PShutdown
  sdp: ShutdownProc
  # write...
  wp: WriteProc
  write: PWrite
  # signal...
  signal: PSignal
  sp: SignalProc
  # pipe...
  pipe, pipe2: PPipe
  pnp: PipeConnectionProc
  prp: PipeReadProc
  # tcp...
  tcp, tcp2: PTcp
  # udp...
  udp, udp2: PUdp
  udps: PUdpSend
  urp: UdpRecvProc
  usp: UdpSendProc

##########
# public #
##########

{.push cdecl.}
{.push header: "uv.h".}

#################################################
# loop: http://docs.libuv.org/en/v1.x/loop.html #
#################################################

# init...

## http://docs.libuv.org/en/v1.x/loop.html#c.uv_default_loop
proc default_loop*(): PLoop {.importc: "uv_default_loop".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_init
proc init*(loop): cint {.importc: "uv_loop_init".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_configure
proc config*(loop, option): cint {.varargs, importc: "uv_loop_configure".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_run
proc run*(loop, mode): cint {.importc: "uv_run".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_alive
proc is_alive*(loop): cint {.importc: "uv_loop_alive".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_stop
proc stop*(loop) {.importc: "uv_stop".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_close
proc close*(loop): cint {.importc: "uv_loop_close".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_backend_fd
proc backend_fd*(loop): cint {.importc: "uv_backend_fd".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_backend_timeout
proc backend_timeout*(loop): cint {.importc: "uv_backend_timeout".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_now
proc now*(loop): uint64 {.importc: "uv_now".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_update_time
proc update_time*(loop) {.importc: "uv_update_time".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_fork
proc fork*(loop): cint {.importc: "uv_loop_fork".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_loop_size
proc size*(): int {.importc: "uv_loop_size".}
## http://docs.libuv.org/en/v1.x/loop.html#c.uv_walk
proc walk*(loop, wp, p) {.importc: "uv_walk".}

#####################################################
# stream: http://docs.libuv.org/en/v1.x/stream.html #
#####################################################

# init...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_accept
proc accept*(stream, stream2): cint {.importc: "uv_accept".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc listen*(stream, ci, cnp): cint {.importc: "uv_listen".}

# read...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_start
proc start_read*(stream, ap, rp): cint {.importc: "uv_read_start".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_stop
proc stop_read*(stream): cint {.importc: "uv_read_stop".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_readable
proc is_readable*(stream): cint {.importc: "uv_is_readable".}

# write...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write
proc write*(write, stream, buffer, flag, wp): cint {.importc: "uv_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write2
proc write2*(write, stream, buffer, flag, stream2, wp): cint {.importc: "uv_write2".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_try_write
proc try_write*(stream, buffer, flag): cint {.importc: "uv_try_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_writable
proc is_writable*(stream): cint {.importc: "uv_is_writable".}

# shutdown...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown
proc shutdown*(sd, stream, sdp): cint {.importc: "uv_shutdown".}

# miscellaneous...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_stream_set_blocking
proc set_blocking*(stream, ci): cint {.importc: "uv_stream_set_blocking".}

#####################################################
# handle: http://docs.libuv.org/en/v1.x/handle.html #
#####################################################

# buffer...

## http://docs.libuv.org/en/v1.x/misc.html#c.uv_buf_init
proc new_buffer*(cs, flag): Buffer {.importc: "uv_buf_init".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_send_buffer_size
proc send_buffer_size*(handle, pci): cint {.importc: "uv_send_buffer_size".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_recv_buffer_size
proc recv_buffer_size*(handle, pci): cint {.importc: "uv_recv_buffer_size".}

# ref: http://docs.libuv.org/en/v1.x/handle.html#reference-counting

## http://docs.libuv.org/en/v1.x/handle.html#c.uv_ref
proc `ref`*(handle) {.importc: "uv_ref".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_unref
proc unref*(handle) {.importc: "uv_unref".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_has_ref
proc has_ref*(handle): cint {.importc: "uv_has_ref".}

# status...

## http://docs.libuv.org/en/v1.x/misc.html#c.uv_guess_handle
proc guess_handle*(file): HandleType {.importc: "uv_guess_handle".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_is_active
proc is_active*(handle): cint {.importc: "uv_is_active".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_handle_size
proc handle_size*(ht): int {.importc: "uv_handle_size".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_fileno
proc file_number*(handle, file): cint {.importc: "uv_fileno".}

# close...

## http://docs.libuv.org/en/v1.x/handle.html#c.uv_close
proc close*(handle, clp) {.importc: "uv_close".}
## http://docs.libuv.org/en/v1.x/handle.html#c.uv_is_closing
proc is_closing*(handle): cint {.importc: "uv_is_closing".}
## http://docs.libuv.org/en/v1.x/request.html#c.uv_cancel
proc cancel*(req: PReq): cint {.importc: "uv_cancel".}
## http://docs.libuv.org/en/v1.x/request.html#c.uv_req_size
proc req_size*(t: ReqType): int {.importc: "uv_req_size".}

#####################################################
## error: http://docs.libuv.org/en/v1.x/errors.html #
#####################################################

## http://docs.libuv.org/en/v1.x/errors.html#c.uv_err_name
proc err_name*(ci): cstring {.importc: "uv_err_name".}
## http://docs.libuv.org/en/v1.x/errors.html#c.uv_strerror
proc str_error*(ci): cstring {.importc: "uv_strerror".}
## http://docs.libuv.org/en/v1.x/errors.html#c.uv_err_name
proc translate_sys_error*(ci): cint {.importc: "uv_translate_sys_error".}

# version...

## http://docs.libuv.org/en/v1.x/version.html#c.uv_version
proc version*(): cuint {.importc: "uv_version".}
## http://docs.libuv.org/en/v1.x/version.html#c.uv_version_string
proc version_string*(): cstring {.importc: "uv_version_string".}

#####################################################
# signal: http://docs.libuv.org/en/v1.x/signal.html #
#####################################################

## http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_init
proc init*(loop, signal): cint {.importc: "uv_signal_init".}
## http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_start
proc start*(signal, sp, ci): cint {.importc: "uv_signal_start".}
## http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_start_oneshot
proc start_oneshot*(signal, sp, ci): cint {.importc: "uv_signal_start_oneshot".}
## http://docs.libuv.org/en/v1.x/signal.html#c.uv_signal_stop
proc stop*(signal): cint {.importc: "uv_signal_stop".}

#################################################
# idle: http://docs.libuv.org/en/v1.x/idle.html #
#################################################

## http://docs.libuv.org/en/v1.x/idle.html#c.uv_idle_init
proc init*(loop, idle): cint {.importc: "uv_idle_init".}
## http://docs.libuv.org/en/v1.x/idle.html#c.uv_idle_start
proc start*(idle, ip): cint {.importc: "uv_idle_start".}
## http://docs.libuv.org/en/v1.x/idle.html#c.uv_idle_stop
proc stop*(idle): cint {.importc: "uv_idle_stop".}

#######################################################
# prepare: http://docs.libuv.org/en/v1.x/prepare.html #
#######################################################

## http://docs.libuv.org/en/v1.x/prepare.html#c.uv_prepare_init
proc init*(loop, prepare): cint {.importc: "uv_prepare_init".}
## http://docs.libuv.org/en/v1.x/prepare.html#c.uv_prepare_start
proc start*(prepare, pp): cint {.importc: "uv_prepare_start".}
## http://docs.libuv.org/en/v1.x/prepare.html#c.uv_prepare_stop
proc stop*(prepare): cint {.importc: "uv_prepare_stop".}

###################################################
# check: http://docs.libuv.org/en/v1.x/check.html #
###################################################

## http://docs.libuv.org/en/v1.x/check.html#c.uv_check_init
proc init*(loop, check): cint {.importc: "uv_check_init".}
## http://docs.libuv.org/en/v1.x/check.html#c.uv_check_start
proc start*(check, chp): cint {.importc: "uv_check_start".}
## http://docs.libuv.org/en/v1.x/check.html#c.uv_check_stop
proc stop*(check): cint {.importc: "uv_check_stop".}

#################################################
# pipe: http://docs.libuv.org/en/v1.x/pipe.html #
#################################################

# init...

## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_init
proc init*(loop, pipe, ci): cint {.importc: "uv_pipe_init".}

# server...

## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_open
proc open*(pipe, file): cint {.importc: "uv_pipe_open".}
## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_getsockname
proc sock*(pipe, cs, size): cint {.importc: "uv_pipe_getsockname".}
## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_bind
proc listen*(pipe, path): cint {.importc: "uv_pipe_bind".}

# client...

## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_connect
proc connect*(connect, pipe, path, cp) {.importc: "uv_pipe_connect".}
## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_getpeername
proc peer*(pipe, cs, size): cint {.importc: "uv_pipe_getpeername".}

# pending...

## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_pending_count
proc pending_count*(pipe): cint {.importc: "uv_pipe_pending_count".}
## http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_pending_type
proc pending_type*(pipe): HandleType {.importc: "uv_pipe_pending_type".}

# Windows only
when defined(windows):
  # http://docs.libuv.org/en/v1.x/pipe.html#c.uv_pipe_pending_instances
  proc pending_instances*(pipe, ci) {.importc: "uv_pipe_pending_instances".}

# server...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc accept*(pipe, pipe2): cint {.importc: "uv_accept".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc listen*(pipe, ci, pnp): cint {.importc: "uv_listen".}

# read...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_start
proc start_read*(pipe, ap, prp): cint {.importc: "uv_read_start".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_stop
proc stop_read*(pipe): cint {.importc: "uv_read_stop".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_readable
proc is_readable*(pipe): cint {.importc: "uv_is_readable".}

# write...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write
proc write*(write, pipe, buffer, flag, wp): cint {.importc: "uv_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write2
proc write2*(write, pipe, buffer, flag, pipe2, wp): cint {.importc: "uv_write2".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_try_write
proc try_write*(pipe, buffer, flag): cint {.importc: "uv_try_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_writable
proc is_writable*(pipe): cint {.importc: "uv_is_writable".}

# shutdown...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown
proc shutdown*(sd, pipe, sdp): cint {.importc: "uv_shutdown".}

# miscellaneous....

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_stream_set_blocking
proc set_blocking*(pipe, ci): cint {.importc: "uv_stream_set_blocking".}

###############################################
# TCP: http://docs.libuv.org/en/v1.x/tcp.html #
###############################################

# init...

## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_init
proc init*(loop, tcp): cint {.importc: "uv_tcp_init".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_init_ex
proc init_ex*(loop, tcp, flag): cint {.importc: "uv_tcp_init_ex".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_open
proc open*(tcp, sock): cint {.importc: "uv_tcp_open".}

# config...

## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_keepalive
proc keep_alive*(tcp, ci, flag): cint {.importc: "uv_tcp_keepalive".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_nodelay
proc no_delay*(tcp, ci): cint {.importc: "uv_tcp_nodelay".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_simultaneous_accepts
proc simultaneous_accepts*(tcp, ci): cint {.importc: "uv_tcp_simultaneous_accepts".}

# server...

## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_bind
proc listen*(tcp, address, flag): cint {.importc: "uv_tcp_bind".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_getsockname
proc sock*(tcp, address, pci): cint {.importc: "uv_tcp_getsockname".}

# client...

## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_connect
proc connect*(connect, tcp, address, cp): cint {.importc: "uv_tcp_connect".}
## http://docs.libuv.org/en/v1.x/tcp.html#c.uv_tcp_getpeername
proc peer*(tcp, address, pci): cint {.importc: "uv_tcp_getpeername".}

# server...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc accept*(tcp, tcp2): cint {.importc: "uv_accept".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc listen*(tcp, ci, pnp): cint {.importc: "uv_listen".}

# read...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_start
proc start_read*(tcp, ap, prp): cint {.importc: "uv_read_start".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_stop
proc stop_read*(tcp): cint {.importc: "uv_read_stop".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_readable
proc is_readable*(tcp): cint {.importc: "uv_is_readable".}

# write...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write
proc write*(write, tcp, buffer, flag, wp): cint {.importc: "uv_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write2
proc write2*(write, tcp, buffer, flag, tcp2, wp): cint {.importc: "uv_write2".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_try_write
proc try_write*(tcp, buffer, flag): cint {.importc: "uv_try_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_writable
proc is_writable*(tcp): cint {.importc: "uv_is_writable".}

# shutdown...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown
proc shutdown*(sd, tcp, sdp): cint {.importc: "uv_shutdown".}

# miscellaneous....

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_stream_set_blocking
proc set_blocking*(tcp, ci): cint {.importc: "uv_stream_set_blocking".}

###############################################
# UDP: http://docs.libuv.org/en/v1.x/udp.html #
###############################################

# init...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_init
proc init*(loop, udp): cint {.importc: "uv_udp_init".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_init_ex
proc init_ex*(loop, udp, flag): cint {.importc: "uv_udp_init_ex".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_open
proc open*(udp, sock): cint {.importc: "uv_udp_open".}

# config...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_ttl
proc ttl*(udp, ci): cint {.importc: "uv_udp_set_ttl".}

# multicast...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_membership
proc membership*(udp; path; cs; um: UdpMembership): cint {.importc: "uv_udp_set_membership".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_multicast_loop
proc multicast_loop*(udp, ci): cint {.importc: "uv_udp_set_multicast_loop".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_multicast_ttl
proc multicast_ttl*(udp, ci): cint {.importc: "uv_udp_set_multicast_ttl".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_multicast_interface
proc multicast_interface*(udp, cs): cint {.importc: "uv_udp_set_multicast_interface".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_set_broadcast
proc broadcast*(udp, ci): cint {.importc: "uv_udp_set_broadcast".}

# server...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_bind
proc listen*(udp, address, flag): cint {.importc: "uv_udp_bind".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_getsockname
proc sock*(udp, address, pci): cint {.importc: "uv_udp_getsockname".}

# send...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_send
proc send*(udps, udp, buffer, flag, address, usp): cint {.importc: "uv_udp_send".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_try_send
proc try_send*(udp, buffer, flag, address): cint {.importc: "uv_udp_try_send".}

# receive...

## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_recv_start
proc recv_start*(udp, ap, urp): cint {.importc: "uv_udp_recv_start".}
## http://docs.libuv.org/en/v1.x/udp.html#c.uv_udp_recv_stop
proc recv_stop*(udp): cint {.importc: "uv_udp_recv_stop".}

# server...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc accept*(udp, pipe2): cint {.importc: "uv_accept".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_listen
proc listen*(udp, ci, pnp): cint {.importc: "uv_listen".}

# read...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_start
proc start_read*(udp, ap, prp): cint {.importc: "uv_read_start".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_read_stop
proc stop_read*(udp): cint {.importc: "uv_read_stop".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_readable
proc is_readable*(udp): cint {.importc: "uv_is_readable".}

# write...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write
proc write*(write, udp, buffer, flag, wp): cint {.importc: "uv_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_write2
proc write2*(write, udp, buffer, flag, pipe2, wp): cint {.importc: "uv_write2".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_try_write
proc try_write*(udp, buffer, flag): cint {.importc: "uv_try_write".}
## http://docs.libuv.org/en/v1.x/stream.html#c.uv_is_writable
proc is_writable*(udp): cint {.importc: "uv_is_writable".}

# shutdown...

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_shutdown
proc shutdown*(sd, udp, sdp): cint {.importc: "uv_shutdown".}

# miscellaneous....

## http://docs.libuv.org/en/v1.x/stream.html#c.uv_stream_set_blocking
proc set_blocking*(udp, ci): cint {.importc: "uv_stream_set_blocking".}

{.pop.}
{.pop.}

###########
# exports #
###########

export
  # stdlib...
  SocketHandle
