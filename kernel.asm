
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 30 10 80       	mov    $0x80103090,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 71 10 80       	push   $0x80107140
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 d1 43 00 00       	call   80104430 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 71 10 80       	push   $0x80107147
80100097:	50                   	push   %eax
80100098:	e8 53 42 00 00       	call   801042f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 c3 44 00 00       	call   801045b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 09 45 00 00       	call   80104670 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 41 00 00       	call   80104330 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 71 10 80       	push   $0x8010714e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 09 42 00 00       	call   801043d0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 71 10 80       	push   $0x8010715f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 c8 41 00 00       	call   801043d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 41 00 00       	call   80104390 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 8c 43 00 00       	call   801045b0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 43 00 00       	jmp    80104670 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 71 10 80       	push   $0x80107166
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 fa 42 00 00       	call   801045b0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 86 3c 00 00       	call   80103f70 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 36 00 00       	call   801039b0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 5d 43 00 00       	call   80104670 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 06 43 00 00       	call   80104670 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 3e 25 00 00       	call   801028f0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 71 10 80       	push   $0x8010716d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 97 7a 10 80 	movl   $0x80107a97,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 40 00 00       	call   80104450 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 71 10 80       	push   $0x80107181
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 01 59 00 00       	call   80105d30 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 16 58 00 00       	call   80105d30 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 0a 58 00 00       	call   80105d30 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 fe 57 00 00       	call   80105d30 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 fa 41 00 00       	call   80104760 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 41 00 00       	call   801046c0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 71 10 80       	push   $0x80107185
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 71 10 80 	movzbl -0x7fef8e50(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 4c 3f 00 00       	call   801045b0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 d4 3f 00 00       	call   80104670 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 71 10 80       	mov    $0x80107198,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 ee 3d 00 00       	call   801045b0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 43 3e 00 00       	call   80104670 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 71 10 80       	push   $0x8010719f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 34 3d 00 00       	call   801045b0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 9c 3c 00 00       	call   80104670 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 1c 38 00 00       	jmp    80104220 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 0b 37 00 00       	call   80104130 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 71 10 80       	push   $0x801071a8
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 e7 39 00 00       	call   80104430 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 1b 2f 00 00       	call   801039b0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 e0 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 08 23 00 00       	call   80102df0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 8f 63 00 00       	call   80106ea0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 48 61 00 00       	call   80106cc0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 42 60 00 00       	call   80106bf0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 30 62 00 00       	call   80106e20 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 ca 21 00 00       	call   80102df0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 89 60 00 00       	call   80106cc0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 e8 62 00 00       	call   80106f40 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 18 3c 00 00       	call   801048c0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 05 3c 00 00       	call   801048c0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 d4 63 00 00       	call   801070a0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 3a 61 00 00       	call   80106e20 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 68 63 00 00       	call   801070a0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 0a 3b 00 00       	call   80104880 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 be 5c 00 00       	call   80106a60 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 76 60 00 00       	call   80106e20 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 37 20 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 71 10 80       	push   $0x801071c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 cd 71 10 80       	push   $0x801071cd
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 37 36 00 00       	call   80104430 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 96 37 00 00       	call   801045b0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 2a 38 00 00       	call   80104670 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 11 38 00 00       	call   80104670 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 28 37 00 00       	call   801045b0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 cb 37 00 00       	call   80104670 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 71 10 80       	push   $0x801071d4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 d6 36 00 00       	call   801045b0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 5b 37 00 00       	call   80104670 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 2d 37 00 00       	jmp    80104670 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 33 1e 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 89 1e 00 00       	jmp    80102df0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 d2 25 00 00       	call   80103550 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 71 10 80       	push   $0x801071dc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 86 26 00 00       	jmp    801036f0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 71 10 80       	push   $0x801071e6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 fa 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 61 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 9a 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 71 10 80       	push   $0x801071ef
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 5a 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 71 10 80       	push   $0x801071f5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 5e 1d 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 ff 71 10 80       	push   $0x801071ff
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 12 72 10 80       	push   $0x80107212
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 6e 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 a6 33 00 00       	call   801046c0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 3e 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 09 11 80       	push   $0x801109e0
8010135a:	e8 51 32 00 00       	call   801045b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 09 11 80       	push   $0x801109e0
801013c7:	e8 a4 32 00 00       	call   80104670 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 76 32 00 00       	call   80104670 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 28 72 10 80       	push   $0x80107228
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 b6 1a 00 00       	call   80102f60 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 38 72 10 80       	push   $0x80107238
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 36 32 00 00       	call   80104760 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 4b 72 10 80       	push   $0x8010724b
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 d1 2e 00 00       	call   80104430 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 72 10 80       	push   $0x80107252
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 74 2d 00 00       	call   801042f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010159d:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015af:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015b5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015bb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015c1:	68 b8 72 10 80       	push   $0x801072b8
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 5d 30 00 00       	call   801046c0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 eb 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 58 72 10 80       	push   $0x80107258
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 56 30 00 00       	call   80104760 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 4e 18 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 09 11 80       	push   $0x801109e0
80101743:	e8 68 2e 00 00       	call   801045b0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101753:	e8 18 2f 00 00       	call   80104670 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 a5 2b 00 00       	call   80104330 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 63 2f 00 00       	call   80104760 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 72 10 80       	push   $0x80107270
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 72 10 80       	push   $0x8010726a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 74 2b 00 00       	call   801043d0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 18 2b 00 00       	jmp    80104390 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 72 10 80       	push   $0x8010727f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 87 2a 00 00       	call   80104330 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 cd 2a 00 00       	call   80104390 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ca:	e8 e1 2c 00 00       	call   801045b0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 87 2d 00 00       	jmp    80104670 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 09 11 80       	push   $0x801109e0
801018f8:	e8 b3 2c 00 00       	call   801045b0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101907:	e8 64 2d 00 00       	call   80104670 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 54 2c 00 00       	call   80104760 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 58 2b 00 00       	call   80104760 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 50 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 29 2b 00 00       	call   801047d0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 c6 2a 00 00       	call   801047d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 99 72 10 80       	push   $0x80107299
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 72 10 80       	push   $0x80107287
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 21 1c 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 09 11 80       	push   $0x801109e0
80101d9c:	e8 0f 28 00 00       	call   801045b0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dac:	e8 bf 28 00 00       	call   80104670 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 44 29 00 00       	call   80104760 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 b8 28 00 00       	call   80104760 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 46 28 00 00       	call   80104820 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 a8 72 10 80       	push   $0x801072a8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 7e 78 10 80       	push   $0x8010787e
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 14 73 10 80       	push   $0x80107314
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 0b 73 10 80       	push   $0x8010730b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 26 73 10 80       	push   $0x80107326
8010215f:	68 80 a5 10 80       	push   $0x8010a580
80102164:	e8 c7 22 00 00       	call   80104430 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 a0 d6 14 80       	mov    0x8014d6a0,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 a5 10 80       	push   $0x8010a580
801021f2:	e8 b9 23 00 00       	call   801045b0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 de 1e 00 00       	call   80104130 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 a5 10 80       	push   $0x8010a580
8010226b:	e8 00 24 00 00       	call   80104670 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 39 21 00 00       	call   801043d0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 a5 10 80       	push   $0x8010a580
801022cc:	e8 df 22 00 00       	call   801045b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 a5 10 80       	push   $0x8010a580
80102318:	53                   	push   %ebx
80102319:	e8 52 1c 00 00       	call   80103f70 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 35 23 00 00       	jmp    80104670 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 55 73 10 80       	push   $0x80107355
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 40 73 10 80       	push   $0x80107340
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 2a 73 10 80       	push   $0x8010732a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 00 d1 14 80 	movzbl 0x8014d100,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 74 73 10 80       	push   $0x80107374
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // struct run *r;
  char* c;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	0f 85 93 00 00 00    	jne    8010251d <kfree+0xad>
8010248a:	81 fb 48 fe 14 80    	cmp    $0x8014fe48,%ebx
80102490:	0f 82 87 00 00 00    	jb     8010251d <kfree+0xad>
80102496:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010249c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a1:	77 7a                	ja     8010251d <kfree+0xad>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024a3:	83 ec 04             	sub    $0x4,%esp
801024a6:	68 00 10 00 00       	push   $0x1000
801024ab:	6a 01                	push   $0x1
801024ad:	53                   	push   %ebx
801024ae:	e8 0d 22 00 00       	call   801046c0 <memset>

  if(kmem.use_lock)
801024b3:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024b9:	83 c4 10             	add    $0x10,%esp
801024bc:	85 d2                	test   %edx,%edx
801024be:	75 20                	jne    801024e0 <kfree+0x70>
    acquire(&kmem.lock);
  c = (char*)v;
  // r->next = kmem.freelist;
  // kmem.freelist = r;

  arr[kmem.count] = c;
801024c0:	a1 78 26 11 80       	mov    0x80112678,%eax
801024c5:	89 1c 85 80 26 11 80 	mov    %ebx,-0x7feed980(,%eax,4)
  kmem.count = kmem.count + 1;
801024cc:	83 c0 01             	add    $0x1,%eax
801024cf:	a3 78 26 11 80       	mov    %eax,0x80112678

  if(kmem.use_lock)
    release(&kmem.lock);
}
801024d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d7:	c9                   	leave  
801024d8:	c3                   	ret    
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 40 26 11 80       	push   $0x80112640
801024e8:	e8 c3 20 00 00       	call   801045b0 <acquire>
  arr[kmem.count] = c;
801024ed:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801024f2:	83 c4 10             	add    $0x10,%esp
  arr[kmem.count] = c;
801024f5:	89 1c 85 80 26 11 80 	mov    %ebx,-0x7feed980(,%eax,4)
  kmem.count = kmem.count + 1;
801024fc:	83 c0 01             	add    $0x1,%eax
801024ff:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102504:	a1 74 26 11 80       	mov    0x80112674,%eax
80102509:	85 c0                	test   %eax,%eax
8010250b:	74 c7                	je     801024d4 <kfree+0x64>
    release(&kmem.lock);
8010250d:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102517:	c9                   	leave  
    release(&kmem.lock);
80102518:	e9 53 21 00 00       	jmp    80104670 <release>
    panic("kfree");
8010251d:	83 ec 0c             	sub    $0xc,%esp
80102520:	68 a6 73 10 80       	push   $0x801073a6
80102525:	e8 66 de ff ff       	call   80100390 <panic>
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102530 <freerange>:
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102538:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010253b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010253f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102545:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102551:	39 de                	cmp    %ebx,%esi
80102553:	72 1f                	jb     80102574 <freerange+0x44>
80102555:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 03 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 f3                	cmp    %esi,%ebx
80102572:	76 e4                	jbe    80102558 <freerange+0x28>
}
80102574:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret    
8010257b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010257f:	90                   	nop

80102580 <kinit1>:
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	56                   	push   %esi
80102588:	53                   	push   %ebx
80102589:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010258c:	83 ec 08             	sub    $0x8,%esp
8010258f:	68 ac 73 10 80       	push   $0x801073ac
80102594:	68 40 26 11 80       	push   $0x80112640
80102599:	e8 92 1e 00 00       	call   80104430 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	83 c4 10             	add    $0x10,%esp
  kmem.count = 0;
801025a4:	c7 05 78 26 11 80 00 	movl   $0x0,0x80112678
801025ab:	00 00 00 
  kmem.use_lock = 0;
801025ae:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801025b5:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025b8:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ca:	39 de                	cmp    %ebx,%esi
801025cc:	72 1e                	jb     801025ec <kinit1+0x6c>
801025ce:	66 90                	xchg   %ax,%ax
    kfree(p);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025df:	50                   	push   %eax
801025e0:	e8 8b fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e5:	83 c4 10             	add    $0x10,%esp
801025e8:	39 de                	cmp    %ebx,%esi
801025ea:	73 e4                	jae    801025d0 <kinit1+0x50>
}
801025ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025ef:	5b                   	pop    %ebx
801025f0:	5e                   	pop    %esi
801025f1:	5d                   	pop    %ebp
801025f2:	c3                   	ret    
801025f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102600 <kinit2>:
{
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102608:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010260b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010260e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010260f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102615:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102621:	39 de                	cmp    %ebx,%esi
80102623:	72 1f                	jb     80102644 <kinit2+0x44>
80102625:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 33 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret    
80102655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	f3 0f 1e fb          	endbr32 
80102664:	55                   	push   %ebp
80102665:	89 e5                	mov    %esp,%ebp
80102667:	53                   	push   %ebx
80102668:	83 ec 04             	sub    $0x4,%esp
  // struct run *r;
  char* c;

  if(kmem.use_lock)
8010266b:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102671:	85 d2                	test   %edx,%edx
80102673:	75 23                	jne    80102698 <kalloc+0x38>
    acquire(&kmem.lock);
  // r = kmem.freelist;

  kmem.count -= 1;
80102675:	a1 78 26 11 80       	mov    0x80112678,%eax
8010267a:	83 e8 01             	sub    $0x1,%eax
8010267d:	a3 78 26 11 80       	mov    %eax,0x80112678
  c = arr[kmem.count];
80102682:	8b 1c 85 80 26 11 80 	mov    -0x7feed980(,%eax,4),%ebx

  if(kmem.count == -1) {
80102689:	83 f8 ff             	cmp    $0xffffffff,%eax
8010268c:	74 39                	je     801026c7 <kalloc+0x67>
  //   kmem.freelist = r->next;

  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)c;
}
8010268e:	89 d8                	mov    %ebx,%eax
80102690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102693:	c9                   	leave  
80102694:	c3                   	ret    
80102695:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	68 40 26 11 80       	push   $0x80112640
801026a0:	e8 0b 1f 00 00       	call   801045b0 <acquire>
  kmem.count -= 1;
801026a5:	a1 78 26 11 80       	mov    0x80112678,%eax
801026aa:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(kmem.count == -1) {
801026b0:	83 c4 10             	add    $0x10,%esp
  kmem.count -= 1;
801026b3:	83 e8 01             	sub    $0x1,%eax
801026b6:	a3 78 26 11 80       	mov    %eax,0x80112678
  c = arr[kmem.count];
801026bb:	8b 1c 85 80 26 11 80 	mov    -0x7feed980(,%eax,4),%ebx
  if(kmem.count == -1) {
801026c2:	83 f8 ff             	cmp    $0xffffffff,%eax
801026c5:	75 0a                	jne    801026d1 <kalloc+0x71>
    kmem.count = 0;
801026c7:	c7 05 78 26 11 80 00 	movl   $0x0,0x80112678
801026ce:	00 00 00 
  if(kmem.use_lock)
801026d1:	85 d2                	test   %edx,%edx
801026d3:	74 b9                	je     8010268e <kalloc+0x2e>
    release(&kmem.lock);
801026d5:	83 ec 0c             	sub    $0xc,%esp
801026d8:	68 40 26 11 80       	push   $0x80112640
801026dd:	e8 8e 1f 00 00       	call   80104670 <release>
}
801026e2:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026e4:	83 c4 10             	add    $0x10,%esp
}
801026e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ea:	c9                   	leave  
801026eb:	c3                   	ret    
801026ec:	66 90                	xchg   %ax,%ax
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026f0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f4:	ba 64 00 00 00       	mov    $0x64,%edx
801026f9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026fa:	a8 01                	test   $0x1,%al
801026fc:	0f 84 be 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
80102702:	55                   	push   %ebp
80102703:	ba 60 00 00 00       	mov    $0x60,%edx
80102708:	89 e5                	mov    %esp,%ebp
8010270a:	53                   	push   %ebx
8010270b:	ec                   	in     (%dx),%al
  return data;
8010270c:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102712:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102715:	3c e0                	cmp    $0xe0,%al
80102717:	74 57                	je     80102770 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102719:	89 d9                	mov    %ebx,%ecx
8010271b:	83 e1 40             	and    $0x40,%ecx
8010271e:	84 c0                	test   %al,%al
80102720:	78 5e                	js     80102780 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102722:	85 c9                	test   %ecx,%ecx
80102724:	74 09                	je     8010272f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102726:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102729:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010272c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010272f:	0f b6 8a e0 74 10 80 	movzbl -0x7fef8b20(%edx),%ecx
  shift ^= togglecode[data];
80102736:	0f b6 82 e0 73 10 80 	movzbl -0x7fef8c20(%edx),%eax
  shift |= shiftcode[data];
8010273d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010273f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102741:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102743:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102749:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010274c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274f:	8b 04 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%eax
80102756:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010275a:	74 0b                	je     80102767 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010275c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275f:	83 fa 19             	cmp    $0x19,%edx
80102762:	77 44                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102764:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102767:	5b                   	pop    %ebx
80102768:	5d                   	pop    %ebp
80102769:	c3                   	ret    
8010276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010277b:	5b                   	pop    %ebx
8010277c:	5d                   	pop    %ebp
8010277d:	c3                   	ret    
8010277e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 c9                	test   %ecx,%ecx
80102785:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102788:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010278a:	0f b6 8a e0 74 10 80 	movzbl -0x7fef8b20(%edx),%ecx
80102791:	83 c9 40             	or     $0x40,%ecx
80102794:	0f b6 c9             	movzbl %cl,%ecx
80102797:	f7 d1                	not    %ecx
80102799:	21 d9                	and    %ebx,%ecx
}
8010279b:	5b                   	pop    %ebx
8010279c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010279d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	5b                   	pop    %ebx
801027af:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027b0:	83 f9 1a             	cmp    $0x1a,%ecx
801027b3:	0f 42 c2             	cmovb  %edx,%eax
}
801027b6:	c3                   	ret    
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	f3 0f 1e fb          	endbr32 
801027d4:	55                   	push   %ebp
801027d5:	89 e5                	mov    %esp,%ebp
801027d7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027da:	68 f0 26 10 80       	push   $0x801026f0
801027df:	e8 7c e0 ff ff       	call   80100860 <consoleintr>
}
801027e4:	83 c4 10             	add    $0x10,%esp
801027e7:	c9                   	leave  
801027e8:	c3                   	ret    
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027f0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027f4:	a1 00 d0 14 80       	mov    0x8014d000,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	0f 84 c7 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
80102801:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102808:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102815:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102818:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102822:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102828:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102835:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010283c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102842:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102849:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284f:	8b 50 30             	mov    0x30(%eax),%edx
80102852:	c1 ea 10             	shr    $0x10,%edx
80102855:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010285b:	75 73                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
8010285d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102864:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010288b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102898:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 7b ff ff ff       	jmp    8010285d <lapicinit+0x6d>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
801028f0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028f4:	a1 00 d0 14 80       	mov    0x8014d000,%eax
801028f9:	85 c0                	test   %eax,%eax
801028fb:	74 0b                	je     80102908 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028fd:	8b 40 20             	mov    0x20(%eax),%eax
80102900:	c1 e8 18             	shr    $0x18,%eax
80102903:	c3                   	ret    
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102908:	31 c0                	xor    %eax,%eax
}
8010290a:	c3                   	ret    
8010290b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102910:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102914:	a1 00 d0 14 80       	mov    0x8014d000,%eax
80102919:	85 c0                	test   %eax,%eax
8010291b:	74 0d                	je     8010292a <lapiceoi+0x1a>
  lapic[index] = value;
8010291d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010292a:	c3                   	ret    
8010292b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010292f:	90                   	nop

80102930 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102930:	f3 0f 1e fb          	endbr32 
}
80102934:	c3                   	ret    
80102935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	f3 0f 1e fb          	endbr32 
80102944:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	b8 0f 00 00 00       	mov    $0xf,%eax
8010294a:	ba 70 00 00 00       	mov    $0x70,%edx
8010294f:	89 e5                	mov    %esp,%ebp
80102951:	53                   	push   %ebx
80102952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102955:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102958:	ee                   	out    %al,(%dx)
80102959:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295e:	ba 71 00 00 00       	mov    $0x71,%edx
80102963:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102964:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102966:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102969:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102971:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102974:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102976:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102979:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010297c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102982:	a1 00 d0 14 80       	mov    0x8014d000,%eax
80102987:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102990:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102997:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029aa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029cb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029cf:	5d                   	pop    %ebp
801029d0:	c3                   	ret    
801029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029ea:	ba 70 00 00 00       	mov    $0x70,%edx
801029ef:	89 e5                	mov    %esp,%ebp
801029f1:	57                   	push   %edi
801029f2:	56                   	push   %esi
801029f3:	53                   	push   %ebx
801029f4:	83 ec 4c             	sub    $0x4c,%esp
801029f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f8:	ba 71 00 00 00       	mov    $0x71,%edx
801029fd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a01:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a06:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a10:	31 c0                	xor    %eax,%eax
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a15:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a20:	89 da                	mov    %ebx,%edx
80102a22:	b8 02 00 00 00       	mov    $0x2,%eax
80102a27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a28:	89 ca                	mov    %ecx,%edx
80102a2a:	ec                   	in     (%dx),%al
80102a2b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2e:	89 da                	mov    %ebx,%edx
80102a30:	b8 04 00 00 00       	mov    $0x4,%eax
80102a35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a36:	89 ca                	mov    %ecx,%edx
80102a38:	ec                   	in     (%dx),%al
80102a39:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3c:	89 da                	mov    %ebx,%edx
80102a3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	89 ca                	mov    %ecx,%edx
80102a46:	ec                   	in     (%dx),%al
80102a47:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4a:	89 da                	mov    %ebx,%edx
80102a4c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a51:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a57:	89 da                	mov    %ebx,%edx
80102a59:	b8 09 00 00 00       	mov    $0x9,%eax
80102a5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5f:	89 ca                	mov    %ecx,%edx
80102a61:	ec                   	in     (%dx),%al
80102a62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a64:	89 da                	mov    %ebx,%edx
80102a66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a6f:	84 c0                	test   %al,%al
80102a71:	78 9d                	js     80102a10 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a73:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a77:	89 fa                	mov    %edi,%edx
80102a79:	0f b6 fa             	movzbl %dl,%edi
80102a7c:	89 f2                	mov    %esi,%edx
80102a7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a81:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	89 da                	mov    %ebx,%edx
80102a8a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a8d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a90:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a94:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a97:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a9a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a9e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa1:	31 c0                	xor    %eax,%eax
80102aa3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa4:	89 ca                	mov    %ecx,%edx
80102aa6:	ec                   	in     (%dx),%al
80102aa7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaa:	89 da                	mov    %ebx,%edx
80102aac:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aaf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ab4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab5:	89 ca                	mov    %ecx,%edx
80102ab7:	ec                   	in     (%dx),%al
80102ab8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abb:	89 da                	mov    %ebx,%edx
80102abd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ac5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac6:	89 ca                	mov    %ecx,%edx
80102ac8:	ec                   	in     (%dx),%al
80102ac9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acc:	89 da                	mov    %ebx,%edx
80102ace:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ad6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad7:	89 ca                	mov    %ecx,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	89 da                	mov    %ebx,%edx
80102adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ae2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ae7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae8:	89 ca                	mov    %ecx,%edx
80102aea:	ec                   	in     (%dx),%al
80102aeb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aee:	89 da                	mov    %ebx,%edx
80102af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102af3:	b8 09 00 00 00       	mov    $0x9,%eax
80102af8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af9:	89 ca                	mov    %ecx,%edx
80102afb:	ec                   	in     (%dx),%al
80102afc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aff:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b05:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b08:	6a 18                	push   $0x18
80102b0a:	50                   	push   %eax
80102b0b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b0e:	50                   	push   %eax
80102b0f:	e8 fc 1b 00 00       	call   80104710 <memcmp>
80102b14:	83 c4 10             	add    $0x10,%esp
80102b17:	85 c0                	test   %eax,%eax
80102b19:	0f 85 f1 fe ff ff    	jne    80102a10 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b1f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b23:	75 78                	jne    80102b9d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b25:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b39:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b50:	89 c2                	mov    %eax,%edx
80102b52:	83 e0 0f             	and    $0xf,%eax
80102b55:	c1 ea 04             	shr    $0x4,%edx
80102b58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 c2                	mov    %eax,%edx
80102b66:	83 e0 0f             	and    $0xf,%eax
80102b69:	c1 ea 04             	shr    $0x4,%edx
80102b6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b75:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b78:	89 c2                	mov    %eax,%edx
80102b7a:	83 e0 0f             	and    $0xf,%eax
80102b7d:	c1 ea 04             	shr    $0x4,%edx
80102b80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b86:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b89:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b8c:	89 c2                	mov    %eax,%edx
80102b8e:	83 e0 0f             	and    $0xf,%eax
80102b91:	c1 ea 04             	shr    $0x4,%edx
80102b94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b9d:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ba3:	89 06                	mov    %eax,(%esi)
80102ba5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba8:	89 46 04             	mov    %eax,0x4(%esi)
80102bab:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bae:	89 46 08             	mov    %eax,0x8(%esi)
80102bb1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bb4:	89 46 0c             	mov    %eax,0xc(%esi)
80102bb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bba:	89 46 10             	mov    %eax,0x10(%esi)
80102bbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bc3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bcd:	5b                   	pop    %ebx
80102bce:	5e                   	pop    %esi
80102bcf:	5f                   	pop    %edi
80102bd0:	5d                   	pop    %ebp
80102bd1:	c3                   	ret    
80102bd2:	66 90                	xchg   %ax,%ax
80102bd4:	66 90                	xchg   %ax,%ax
80102bd6:	66 90                	xchg   %ax,%ax
80102bd8:	66 90                	xchg   %ax,%ax
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d 68 d0 14 80    	mov    0x8014d068,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 54 d0 14 80       	mov    0x8014d054,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 64 d0 14 80    	pushl  0x8014d064
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd 6c d0 14 80 	pushl  -0x7feb2f94(,%edi,4)
80102c24:	ff 35 64 d0 14 80    	pushl  0x8014d064
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 17 1b 00 00       	call   80104760 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d 68 d0 14 80    	cmp    %edi,0x8014d068
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 54 d0 14 80    	pushl  0x8014d054
80102c8d:	ff 35 64 d0 14 80    	pushl  0x8014d064
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 68 d0 14 80       	mov    0x8014d068,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 6c d0 14 80 	mov    -0x7feb2f94(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	f3 0f 1e fb          	endbr32 
80102ce4:	55                   	push   %ebp
80102ce5:	89 e5                	mov    %esp,%ebp
80102ce7:	53                   	push   %ebx
80102ce8:	83 ec 2c             	sub    $0x2c,%esp
80102ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cee:	68 e0 75 10 80       	push   $0x801075e0
80102cf3:	68 20 d0 14 80       	push   $0x8014d020
80102cf8:	e8 33 17 00 00       	call   80104430 <initlock>
  readsb(dev, &sb);
80102cfd:	58                   	pop    %eax
80102cfe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d01:	5a                   	pop    %edx
80102d02:	50                   	push   %eax
80102d03:	53                   	push   %ebx
80102d04:	e8 f7 e7 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d0c:	59                   	pop    %ecx
  log.dev = dev;
80102d0d:	89 1d 64 d0 14 80    	mov    %ebx,0x8014d064
  log.size = sb.nlog;
80102d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d16:	a3 54 d0 14 80       	mov    %eax,0x8014d054
  log.size = sb.nlog;
80102d1b:	89 15 58 d0 14 80    	mov    %edx,0x8014d058
  struct buf *buf = bread(log.dev, log.start);
80102d21:	5a                   	pop    %edx
80102d22:	50                   	push   %eax
80102d23:	53                   	push   %ebx
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d2c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d2f:	89 0d 68 d0 14 80    	mov    %ecx,0x8014d068
  for (i = 0; i < log.lh.n; i++) {
80102d35:	85 c9                	test   %ecx,%ecx
80102d37:	7e 19                	jle    80102d52 <initlog+0x72>
80102d39:	31 d2                	xor    %edx,%edx
80102d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d3f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d40:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d44:	89 1c 95 6c d0 14 80 	mov    %ebx,-0x7feb2f94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d1                	cmp    %edx,%ecx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 68 d0 14 80 00 	movl   $0x0,0x8014d068
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d8a:	68 20 d0 14 80       	push   $0x8014d020
80102d8f:	e8 1c 18 00 00       	call   801045b0 <acquire>
80102d94:	83 c4 10             	add    $0x10,%esp
80102d97:	eb 1c                	jmp    80102db5 <begin_op+0x35>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da0:	83 ec 08             	sub    $0x8,%esp
80102da3:	68 20 d0 14 80       	push   $0x8014d020
80102da8:	68 20 d0 14 80       	push   $0x8014d020
80102dad:	e8 be 11 00 00       	call   80103f70 <sleep>
80102db2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102db5:	a1 60 d0 14 80       	mov    0x8014d060,%eax
80102dba:	85 c0                	test   %eax,%eax
80102dbc:	75 e2                	jne    80102da0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dbe:	a1 5c d0 14 80       	mov    0x8014d05c,%eax
80102dc3:	8b 15 68 d0 14 80    	mov    0x8014d068,%edx
80102dc9:	83 c0 01             	add    $0x1,%eax
80102dcc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dcf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dd2:	83 fa 1e             	cmp    $0x1e,%edx
80102dd5:	7f c9                	jg     80102da0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dd7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dda:	a3 5c d0 14 80       	mov    %eax,0x8014d05c
      release(&log.lock);
80102ddf:	68 20 d0 14 80       	push   $0x8014d020
80102de4:	e8 87 18 00 00       	call   80104670 <release>
      break;
    }
  }
}
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	c9                   	leave  
80102ded:	c3                   	ret    
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	f3 0f 1e fb          	endbr32 
80102df4:	55                   	push   %ebp
80102df5:	89 e5                	mov    %esp,%ebp
80102df7:	57                   	push   %edi
80102df8:	56                   	push   %esi
80102df9:	53                   	push   %ebx
80102dfa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dfd:	68 20 d0 14 80       	push   $0x8014d020
80102e02:	e8 a9 17 00 00       	call   801045b0 <acquire>
  log.outstanding -= 1;
80102e07:	a1 5c d0 14 80       	mov    0x8014d05c,%eax
  if(log.committing)
80102e0c:	8b 35 60 d0 14 80    	mov    0x8014d060,%esi
80102e12:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e15:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e18:	89 1d 5c d0 14 80    	mov    %ebx,0x8014d05c
  if(log.committing)
80102e1e:	85 f6                	test   %esi,%esi
80102e20:	0f 85 1e 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e26:	85 db                	test   %ebx,%ebx
80102e28:	0f 85 f2 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2e:	c7 05 60 d0 14 80 01 	movl   $0x1,0x8014d060
80102e35:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e38:	83 ec 0c             	sub    $0xc,%esp
80102e3b:	68 20 d0 14 80       	push   $0x8014d020
80102e40:	e8 2b 18 00 00       	call   80104670 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e45:	8b 0d 68 d0 14 80    	mov    0x8014d068,%ecx
80102e4b:	83 c4 10             	add    $0x10,%esp
80102e4e:	85 c9                	test   %ecx,%ecx
80102e50:	7f 3e                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e52:	83 ec 0c             	sub    $0xc,%esp
80102e55:	68 20 d0 14 80       	push   $0x8014d020
80102e5a:	e8 51 17 00 00       	call   801045b0 <acquire>
    wakeup(&log);
80102e5f:	c7 04 24 20 d0 14 80 	movl   $0x8014d020,(%esp)
    log.committing = 0;
80102e66:	c7 05 60 d0 14 80 00 	movl   $0x0,0x8014d060
80102e6d:	00 00 00 
    wakeup(&log);
80102e70:	e8 bb 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102e75:	c7 04 24 20 d0 14 80 	movl   $0x8014d020,(%esp)
80102e7c:	e8 ef 17 00 00       	call   80104670 <release>
80102e81:	83 c4 10             	add    $0x10,%esp
}
80102e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e87:	5b                   	pop    %ebx
80102e88:	5e                   	pop    %esi
80102e89:	5f                   	pop    %edi
80102e8a:	5d                   	pop    %ebp
80102e8b:	c3                   	ret    
80102e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 54 d0 14 80       	mov    0x8014d054,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 64 d0 14 80    	pushl  0x8014d064
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d 6c d0 14 80 	pushl  -0x7feb2f94(,%ebx,4)
80102eb4:	ff 35 64 d0 14 80    	pushl  0x8014d064
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 87 18 00 00       	call   80104760 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d 68 d0 14 80    	cmp    0x8014d068,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 68 d0 14 80 00 	movl   $0x0,0x8014d068
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 38 ff ff ff       	jmp    80102e52 <end_op+0x62>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 20 d0 14 80       	push   $0x8014d020
80102f28:	e8 03 12 00 00       	call   80104130 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 20 d0 14 80 	movl   $0x8014d020,(%esp)
80102f34:	e8 37 17 00 00       	call   80104670 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 e4 75 10 80       	push   $0x801075e4
80102f4c:	e8 3f d4 ff ff       	call   80100390 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	f3 0f 1e fb          	endbr32 
80102f64:	55                   	push   %ebp
80102f65:	89 e5                	mov    %esp,%ebp
80102f67:	53                   	push   %ebx
80102f68:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f6b:	8b 15 68 d0 14 80    	mov    0x8014d068,%edx
{
80102f71:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f74:	83 fa 1d             	cmp    $0x1d,%edx
80102f77:	0f 8f 91 00 00 00    	jg     8010300e <log_write+0xae>
80102f7d:	a1 58 d0 14 80       	mov    0x8014d058,%eax
80102f82:	83 e8 01             	sub    $0x1,%eax
80102f85:	39 c2                	cmp    %eax,%edx
80102f87:	0f 8d 81 00 00 00    	jge    8010300e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f8d:	a1 5c d0 14 80       	mov    0x8014d05c,%eax
80102f92:	85 c0                	test   %eax,%eax
80102f94:	0f 8e 81 00 00 00    	jle    8010301b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f9a:	83 ec 0c             	sub    $0xc,%esp
80102f9d:	68 20 d0 14 80       	push   $0x8014d020
80102fa2:	e8 09 16 00 00       	call   801045b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fa7:	8b 15 68 d0 14 80    	mov    0x8014d068,%edx
80102fad:	83 c4 10             	add    $0x10,%esp
80102fb0:	85 d2                	test   %edx,%edx
80102fb2:	7e 4e                	jle    80103002 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fb7:	31 c0                	xor    %eax,%eax
80102fb9:	eb 0c                	jmp    80102fc7 <log_write+0x67>
80102fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop
80102fc0:	83 c0 01             	add    $0x1,%eax
80102fc3:	39 c2                	cmp    %eax,%edx
80102fc5:	74 29                	je     80102ff0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	39 0c 85 6c d0 14 80 	cmp    %ecx,-0x7feb2f94(,%eax,4)
80102fce:	75 f0                	jne    80102fc0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 85 6c d0 14 80 	mov    %ecx,-0x7feb2f94(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fd7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fdd:	c7 45 08 20 d0 14 80 	movl   $0x8014d020,0x8(%ebp)
}
80102fe4:	c9                   	leave  
  release(&log.lock);
80102fe5:	e9 86 16 00 00       	jmp    80104670 <release>
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 6c d0 14 80 	mov    %ecx,-0x7feb2f94(,%edx,4)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 68 d0 14 80    	mov    %edx,0x8014d068
80103000:	eb d5                	jmp    80102fd7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103002:	8b 43 08             	mov    0x8(%ebx),%eax
80103005:	a3 6c d0 14 80       	mov    %eax,0x8014d06c
  if (i == log.lh.n)
8010300a:	75 cb                	jne    80102fd7 <log_write+0x77>
8010300c:	eb e9                	jmp    80102ff7 <log_write+0x97>
    panic("too big a transaction");
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 f3 75 10 80       	push   $0x801075f3
80103016:	e8 75 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010301b:	83 ec 0c             	sub    $0xc,%esp
8010301e:	68 09 76 10 80       	push   $0x80107609
80103023:	e8 68 d3 ff ff       	call   80100390 <panic>
80103028:	66 90                	xchg   %ax,%ax
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	53                   	push   %ebx
80103034:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103037:	e8 54 09 00 00       	call   80103990 <cpuid>
8010303c:	89 c3                	mov    %eax,%ebx
8010303e:	e8 4d 09 00 00       	call   80103990 <cpuid>
80103043:	83 ec 04             	sub    $0x4,%esp
80103046:	53                   	push   %ebx
80103047:	50                   	push   %eax
80103048:	68 24 76 10 80       	push   $0x80107624
8010304d:	e8 5e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103052:	e8 19 29 00 00       	call   80105970 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103057:	e8 c4 08 00 00       	call   80103920 <mycpu>
8010305c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010305e:	b8 01 00 00 00       	mov    $0x1,%eax
80103063:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010306a:	e8 11 0c 00 00       	call   80103c80 <scheduler>
8010306f:	90                   	nop

80103070 <mpenter>:
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010307a:	e8 c1 39 00 00       	call   80106a40 <switchkvm>
  seginit();
8010307f:	e8 2c 39 00 00       	call   801069b0 <seginit>
  lapicinit();
80103084:	e8 67 f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103089:	e8 a2 ff ff ff       	call   80103030 <mpmain>
8010308e:	66 90                	xchg   %ax,%ax

80103090 <main>:
{
80103090:	f3 0f 1e fb          	endbr32 
80103094:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103098:	83 e4 f0             	and    $0xfffffff0,%esp
8010309b:	ff 71 fc             	pushl  -0x4(%ecx)
8010309e:	55                   	push   %ebp
8010309f:	89 e5                	mov    %esp,%ebp
801030a1:	53                   	push   %ebx
801030a2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030a3:	83 ec 08             	sub    $0x8,%esp
801030a6:	68 00 00 40 80       	push   $0x80400000
801030ab:	68 48 fe 14 80       	push   $0x8014fe48
801030b0:	e8 cb f4 ff ff       	call   80102580 <kinit1>
  kvmalloc();      // kernel page table
801030b5:	e8 66 3e 00 00       	call   80106f20 <kvmalloc>
  mpinit();        // detect other processors
801030ba:	e8 81 01 00 00       	call   80103240 <mpinit>
  lapicinit();     // interrupt controller
801030bf:	e8 2c f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
801030c4:	e8 e7 38 00 00       	call   801069b0 <seginit>
  picinit();       // disable pic
801030c9:	e8 52 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030ce:	e8 ad f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
801030d3:	e8 58 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030d8:	e8 93 2b 00 00       	call   80105c70 <uartinit>
  pinit();         // process table
801030dd:	e8 1e 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
801030e2:	e8 09 28 00 00       	call   801058f0 <tvinit>
  binit();         // buffer cache
801030e7:	e8 54 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ec:	e8 ef dc ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030f1:	e8 5a f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030f6:	83 c4 0c             	add    $0xc,%esp
801030f9:	68 8a 00 00 00       	push   $0x8a
801030fe:	68 8c a4 10 80       	push   $0x8010a48c
80103103:	68 00 70 00 80       	push   $0x80007000
80103108:	e8 53 16 00 00       	call   80104760 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010310d:	83 c4 10             	add    $0x10,%esp
80103110:	69 05 a0 d6 14 80 b0 	imul   $0xb0,0x8014d6a0,%eax
80103117:	00 00 00 
8010311a:	05 20 d1 14 80       	add    $0x8014d120,%eax
8010311f:	3d 20 d1 14 80       	cmp    $0x8014d120,%eax
80103124:	76 7a                	jbe    801031a0 <main+0x110>
80103126:	bb 20 d1 14 80       	mov    $0x8014d120,%ebx
8010312b:	eb 1c                	jmp    80103149 <main+0xb9>
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
80103130:	69 05 a0 d6 14 80 b0 	imul   $0xb0,0x8014d6a0,%eax
80103137:	00 00 00 
8010313a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103140:	05 20 d1 14 80       	add    $0x8014d120,%eax
80103145:	39 c3                	cmp    %eax,%ebx
80103147:	73 57                	jae    801031a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103149:	e8 d2 07 00 00       	call   80103920 <mycpu>
8010314e:	39 c3                	cmp    %eax,%ebx
80103150:	74 de                	je     80103130 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103152:	e8 09 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103157:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010315a:	c7 05 f8 6f 00 80 70 	movl   $0x80103070,0x80006ff8
80103161:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103164:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010316b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316e:	05 00 10 00 00       	add    $0x1000,%eax
80103173:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103178:	0f b6 03             	movzbl (%ebx),%eax
8010317b:	68 00 70 00 00       	push   $0x7000
80103180:	50                   	push   %eax
80103181:	e8 ba f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 f6                	je     80103190 <main+0x100>
8010319a:	eb 94                	jmp    80103130 <main+0xa0>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031a0:	83 ec 08             	sub    $0x8,%esp
801031a3:	68 00 00 00 8e       	push   $0x8e000000
801031a8:	68 00 00 40 80       	push   $0x80400000
801031ad:	e8 4e f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
801031b2:	e8 29 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
801031b7:	e8 74 fe ff ff       	call   80103030 <mpmain>
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031cb:	53                   	push   %ebx
  e = addr+len;
801031cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031d2:	39 de                	cmp    %ebx,%esi
801031d4:	72 10                	jb     801031e6 <mpsearch1+0x26>
801031d6:	eb 50                	jmp    80103228 <mpsearch1+0x68>
801031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop
801031e0:	89 fe                	mov    %edi,%esi
801031e2:	39 fb                	cmp    %edi,%ebx
801031e4:	76 42                	jbe    80103228 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e6:	83 ec 04             	sub    $0x4,%esp
801031e9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ec:	6a 04                	push   $0x4
801031ee:	68 38 76 10 80       	push   $0x80107638
801031f3:	56                   	push   %esi
801031f4:	e8 17 15 00 00       	call   80104710 <memcmp>
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	75 e0                	jne    801031e0 <mpsearch1+0x20>
80103200:	89 f2                	mov    %esi,%edx
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103208:	0f b6 0a             	movzbl (%edx),%ecx
8010320b:	83 c2 01             	add    $0x1,%edx
8010320e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103210:	39 fa                	cmp    %edi,%edx
80103212:	75 f4                	jne    80103208 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103214:	84 c0                	test   %al,%al
80103216:	75 c8                	jne    801031e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321b:	89 f0                	mov    %esi,%eax
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010322b:	31 f6                	xor    %esi,%esi
}
8010322d:	5b                   	pop    %ebx
8010322e:	89 f0                	mov    %esi,%eax
80103230:	5e                   	pop    %esi
80103231:	5f                   	pop    %edi
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    
80103234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	57                   	push   %edi
80103248:	56                   	push   %esi
80103249:	53                   	push   %ebx
8010324a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010324d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103254:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010325b:	c1 e0 08             	shl    $0x8,%eax
8010325e:	09 d0                	or     %edx,%eax
80103260:	c1 e0 04             	shl    $0x4,%eax
80103263:	75 1b                	jne    80103280 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103265:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010326c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103273:	c1 e0 08             	shl    $0x8,%eax
80103276:	09 d0                	or     %edx,%eax
80103278:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010327b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103280:	ba 00 04 00 00       	mov    $0x400,%edx
80103285:	e8 36 ff ff ff       	call   801031c0 <mpsearch1>
8010328a:	89 c6                	mov    %eax,%esi
8010328c:	85 c0                	test   %eax,%eax
8010328e:	0f 84 4c 01 00 00    	je     801033e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103294:	8b 5e 04             	mov    0x4(%esi),%ebx
80103297:	85 db                	test   %ebx,%ebx
80103299:	0f 84 61 01 00 00    	je     80103400 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032a8:	6a 04                	push   $0x4
801032aa:	68 3d 76 10 80       	push   $0x8010763d
801032af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b3:	e8 58 14 00 00       	call   80104710 <memcmp>
801032b8:	83 c4 10             	add    $0x10,%esp
801032bb:	85 c0                	test   %eax,%eax
801032bd:	0f 85 3d 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032ca:	3c 01                	cmp    $0x1,%al
801032cc:	74 08                	je     801032d6 <mpinit+0x96>
801032ce:	3c 04                	cmp    $0x4,%al
801032d0:	0f 85 2a 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032dd:	66 85 d2             	test   %dx,%dx
801032e0:	74 26                	je     80103308 <mpinit+0xc8>
801032e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032e7:	31 d2                	xor    %edx,%edx
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032f7:	83 c0 01             	add    $0x1,%eax
801032fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032fc:	39 f8                	cmp    %edi,%eax
801032fe:	75 f0                	jne    801032f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103300:	84 d2                	test   %dl,%dl
80103302:	0f 85 f8 00 00 00    	jne    80103400 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103308:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010330e:	a3 00 d0 14 80       	mov    %eax,0x8014d000
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103313:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103319:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103320:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103325:	03 55 e4             	add    -0x1c(%ebp),%edx
80103328:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010332b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop
80103330:	39 c2                	cmp    %eax,%edx
80103332:	76 15                	jbe    80103349 <mpinit+0x109>
    switch(*p){
80103334:	0f b6 08             	movzbl (%eax),%ecx
80103337:	80 f9 02             	cmp    $0x2,%cl
8010333a:	74 5c                	je     80103398 <mpinit+0x158>
8010333c:	77 42                	ja     80103380 <mpinit+0x140>
8010333e:	84 c9                	test   %cl,%cl
80103340:	74 6e                	je     801033b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103342:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103345:	39 c2                	cmp    %eax,%edx
80103347:	77 eb                	ja     80103334 <mpinit+0xf4>
80103349:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010334c:	85 db                	test   %ebx,%ebx
8010334e:	0f 84 b9 00 00 00    	je     8010340d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103354:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103358:	74 15                	je     8010336f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335a:	b8 70 00 00 00       	mov    $0x70,%eax
8010335f:	ba 22 00 00 00       	mov    $0x22,%edx
80103364:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103365:	ba 23 00 00 00       	mov    $0x23,%edx
8010336a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010336b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	ee                   	out    %al,(%dx)
  }
}
8010336f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5f                   	pop    %edi
80103375:	5d                   	pop    %ebp
80103376:	c3                   	ret    
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	76 ba                	jbe    80103342 <mpinit+0x102>
80103388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010338f:	eb 9f                	jmp    80103330 <mpinit+0xf0>
80103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103398:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010339c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010339f:	88 0d 00 d1 14 80    	mov    %cl,0x8014d100
      continue;
801033a5:	eb 89                	jmp    80103330 <mpinit+0xf0>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033b0:	8b 0d a0 d6 14 80    	mov    0x8014d6a0,%ecx
801033b6:	83 f9 07             	cmp    $0x7,%ecx
801033b9:	7f 19                	jg     801033d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033c5:	83 c1 01             	add    $0x1,%ecx
801033c8:	89 0d a0 d6 14 80    	mov    %ecx,0x8014d6a0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ce:	88 9f 20 d1 14 80    	mov    %bl,-0x7feb2ee0(%edi)
      p += sizeof(struct mpproc);
801033d4:	83 c0 14             	add    $0x14,%eax
      continue;
801033d7:	e9 54 ff ff ff       	jmp    80103330 <mpinit+0xf0>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ea:	e8 d1 fd ff ff       	call   801031c0 <mpsearch1>
801033ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f1:	85 c0                	test   %eax,%eax
801033f3:	0f 85 9b fe ff ff    	jne    80103294 <mpinit+0x54>
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 42 76 10 80       	push   $0x80107642
80103408:	e8 83 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010340d:	83 ec 0c             	sub    $0xc,%esp
80103410:	68 5c 76 10 80       	push   $0x8010765c
80103415:	e8 76 cf ff ff       	call   80100390 <panic>
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	f3 0f 1e fb          	endbr32 
80103424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103429:	ba 21 00 00 00       	mov    $0x21,%edx
8010342e:	ee                   	out    %al,(%dx)
8010342f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103434:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	f3 0f 1e fb          	endbr32 
80103444:	55                   	push   %ebp
80103445:	89 e5                	mov    %esp,%ebp
80103447:	57                   	push   %edi
80103448:	56                   	push   %esi
80103449:	53                   	push   %ebx
8010344a:	83 ec 0c             	sub    $0xc,%esp
8010344d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103450:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103453:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103459:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345f:	e8 9c d9 ff ff       	call   80100e00 <filealloc>
80103464:	89 03                	mov    %eax,(%ebx)
80103466:	85 c0                	test   %eax,%eax
80103468:	0f 84 ac 00 00 00    	je     8010351a <pipealloc+0xda>
8010346e:	e8 8d d9 ff ff       	call   80100e00 <filealloc>
80103473:	89 06                	mov    %eax,(%esi)
80103475:	85 c0                	test   %eax,%eax
80103477:	0f 84 8b 00 00 00    	je     80103508 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010347d:	e8 de f1 ff ff       	call   80102660 <kalloc>
80103482:	89 c7                	mov    %eax,%edi
80103484:	85 c0                	test   %eax,%eax
80103486:	0f 84 b4 00 00 00    	je     80103540 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010348c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103493:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103496:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103499:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034a0:	00 00 00 
  p->nwrite = 0;
801034a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034aa:	00 00 00 
  p->nread = 0;
801034ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b4:	00 00 00 
  initlock(&p->lock, "pipe");
801034b7:	68 7b 76 10 80       	push   $0x8010767b
801034bc:	50                   	push   %eax
801034bd:	e8 6e 0f 00 00       	call   80104430 <initlock>
  (*f0)->type = FD_PIPE;
801034c2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034cd:	8b 03                	mov    (%ebx),%eax
801034cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034d3:	8b 03                	mov    (%ebx),%eax
801034d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e6:	8b 06                	mov    (%esi),%eax
801034e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ec:	8b 06                	mov    (%esi),%eax
801034ee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fa:	31 c0                	xor    %eax,%eax
}
801034fc:	5b                   	pop    %ebx
801034fd:	5e                   	pop    %esi
801034fe:	5f                   	pop    %edi
801034ff:	5d                   	pop    %ebp
80103500:	c3                   	ret    
80103501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103508:	8b 03                	mov    (%ebx),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 1e                	je     8010352c <pipealloc+0xec>
    fileclose(*f0);
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	50                   	push   %eax
80103512:	e8 a9 d9 ff ff       	call   80100ec0 <fileclose>
80103517:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010351a:	8b 06                	mov    (%esi),%eax
8010351c:	85 c0                	test   %eax,%eax
8010351e:	74 0c                	je     8010352c <pipealloc+0xec>
    fileclose(*f1);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	50                   	push   %eax
80103524:	e8 97 d9 ff ff       	call   80100ec0 <fileclose>
80103529:	83 c4 10             	add    $0x10,%esp
}
8010352c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010352f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103534:	5b                   	pop    %ebx
80103535:	5e                   	pop    %esi
80103536:	5f                   	pop    %edi
80103537:	5d                   	pop    %ebp
80103538:	c3                   	ret    
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103540:	8b 03                	mov    (%ebx),%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	75 c8                	jne    8010350e <pipealloc+0xce>
80103546:	eb d2                	jmp    8010351a <pipealloc+0xda>
80103548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	56                   	push   %esi
80103558:	53                   	push   %ebx
80103559:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010355c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	53                   	push   %ebx
80103563:	e8 48 10 00 00       	call   801045b0 <acquire>
  if(writable){
80103568:	83 c4 10             	add    $0x10,%esp
8010356b:	85 f6                	test   %esi,%esi
8010356d:	74 41                	je     801035b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103578:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357f:	00 00 00 
    wakeup(&p->nread);
80103582:	50                   	push   %eax
80103583:	e8 a8 0b 00 00       	call   80104130 <wakeup>
80103588:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010358b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	75 0a                	jne    8010359f <pipeclose+0x4f>
80103595:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010359b:	85 c0                	test   %eax,%eax
8010359d:	74 31                	je     801035d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a5:	5b                   	pop    %ebx
801035a6:	5e                   	pop    %esi
801035a7:	5d                   	pop    %ebp
    release(&p->lock);
801035a8:	e9 c3 10 00 00       	jmp    80104670 <release>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 67 0b 00 00       	call   80104130 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb bd                	jmp    8010358b <pipeclose+0x3b>
801035ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 97 10 00 00       	call   80104670 <release>
    kfree((char*)p);
801035d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035dc:	83 c4 10             	add    $0x10,%esp
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 86 ee ff ff       	jmp    80102470 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	57                   	push   %edi
801035f8:	56                   	push   %esi
801035f9:	53                   	push   %ebx
801035fa:	83 ec 28             	sub    $0x28,%esp
801035fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103600:	53                   	push   %ebx
80103601:	e8 aa 0f 00 00       	call   801045b0 <acquire>
  for(i = 0; i < n; i++){
80103606:	8b 45 10             	mov    0x10(%ebp),%eax
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	85 c0                	test   %eax,%eax
8010360e:	0f 8e bc 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103614:	8b 45 0c             	mov    0xc(%ebp),%eax
80103617:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010361d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103626:	03 45 10             	add    0x10(%ebp),%eax
80103629:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010362c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103632:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103638:	89 ca                	mov    %ecx,%edx
8010363a:	05 00 02 00 00       	add    $0x200,%eax
8010363f:	39 c1                	cmp    %eax,%ecx
80103641:	74 3b                	je     8010367e <pipewrite+0x8e>
80103643:	eb 63                	jmp    801036a8 <pipewrite+0xb8>
80103645:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 63 03 00 00       	call   801039b0 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 d3 0a 00 00       	call   80104130 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 0a 09 00 00       	call   80103f70 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 df 0f 00 00       	call   80104670 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 5c ff ff ff    	jne    8010362c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 51 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 89 0f 00 00       	call   80104670 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	f3 0f 1e fb          	endbr32 
801036f4:	55                   	push   %ebp
801036f5:	89 e5                	mov    %esp,%ebp
801036f7:	57                   	push   %edi
801036f8:	56                   	push   %esi
801036f9:	53                   	push   %ebx
801036fa:	83 ec 18             	sub    $0x18,%esp
801036fd:	8b 75 08             	mov    0x8(%ebp),%esi
80103700:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103703:	56                   	push   %esi
80103704:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010370a:	e8 a1 0e 00 00       	call   801045b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371e:	74 33                	je     80103753 <piperead+0x63>
80103720:	eb 3b                	jmp    8010375d <piperead+0x6d>
80103722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103728:	e8 83 02 00 00       	call   801039b0 <myproc>
8010372d:	8b 48 24             	mov    0x24(%eax),%ecx
80103730:	85 c9                	test   %ecx,%ecx
80103732:	0f 85 88 00 00 00    	jne    801037c0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103738:	83 ec 08             	sub    $0x8,%esp
8010373b:	56                   	push   %esi
8010373c:	53                   	push   %ebx
8010373d:	e8 2e 08 00 00       	call   80103f70 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103742:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103748:	83 c4 10             	add    $0x10,%esp
8010374b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103751:	75 0a                	jne    8010375d <piperead+0x6d>
80103753:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103759:	85 c0                	test   %eax,%eax
8010375b:	75 cb                	jne    80103728 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010375d:	8b 55 10             	mov    0x10(%ebp),%edx
80103760:	31 db                	xor    %ebx,%ebx
80103762:	85 d2                	test   %edx,%edx
80103764:	7f 28                	jg     8010378e <piperead+0x9e>
80103766:	eb 34                	jmp    8010379c <piperead+0xac>
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103770:	8d 48 01             	lea    0x1(%eax),%ecx
80103773:	25 ff 01 00 00       	and    $0x1ff,%eax
80103778:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010377e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103783:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103786:	83 c3 01             	add    $0x1,%ebx
80103789:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010378c:	74 0e                	je     8010379c <piperead+0xac>
    if(p->nread == p->nwrite)
8010378e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103794:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010379a:	75 d4                	jne    80103770 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010379c:	83 ec 0c             	sub    $0xc,%esp
8010379f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037a5:	50                   	push   %eax
801037a6:	e8 85 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801037ab:	89 34 24             	mov    %esi,(%esp)
801037ae:	e8 bd 0e 00 00       	call   80104670 <release>
  return i;
801037b3:	83 c4 10             	add    $0x10,%esp
}
801037b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b9:	89 d8                	mov    %ebx,%eax
801037bb:	5b                   	pop    %ebx
801037bc:	5e                   	pop    %esi
801037bd:	5f                   	pop    %edi
801037be:	5d                   	pop    %ebp
801037bf:	c3                   	ret    
      release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037c8:	56                   	push   %esi
801037c9:	e8 a2 0e 00 00       	call   80104670 <release>
      return -1;
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	89 d8                	mov    %ebx,%eax
801037d6:	5b                   	pop    %ebx
801037d7:	5e                   	pop    %esi
801037d8:	5f                   	pop    %edi
801037d9:	5d                   	pop    %ebp
801037da:	c3                   	ret    
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb f4 d6 14 80       	mov    $0x8014d6f4,%ebx
{
801037e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ec:	68 c0 d6 14 80       	push   $0x8014d6c0
801037f1:	e8 ba 0d 00 00       	call   801045b0 <acquire>
801037f6:	83 c4 10             	add    $0x10,%esp
801037f9:	eb 10                	jmp    8010380b <allocproc+0x2b>
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	83 c3 7c             	add    $0x7c,%ebx
80103803:	81 fb f4 f5 14 80    	cmp    $0x8014f5f4,%ebx
80103809:	74 75                	je     80103880 <allocproc+0xa0>
    if(p->state == UNUSED)
8010380b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010380e:	85 c0                	test   %eax,%eax
80103810:	75 ee                	jne    80103800 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103812:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103817:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010381a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103821:	89 43 10             	mov    %eax,0x10(%ebx)
80103824:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103827:	68 c0 d6 14 80       	push   $0x8014d6c0
  p->pid = nextpid++;
8010382c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103832:	e8 39 0e 00 00       	call   80104670 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103837:	e8 24 ee ff ff       	call   80102660 <kalloc>
8010383c:	83 c4 10             	add    $0x10,%esp
8010383f:	89 43 08             	mov    %eax,0x8(%ebx)
80103842:	85 c0                	test   %eax,%eax
80103844:	74 53                	je     80103899 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103846:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010384f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103854:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103857:	c7 40 14 d6 58 10 80 	movl   $0x801058d6,0x14(%eax)
  p->context = (struct context*)sp;
8010385e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103861:	6a 14                	push   $0x14
80103863:	6a 00                	push   $0x0
80103865:	50                   	push   %eax
80103866:	e8 55 0e 00 00       	call   801046c0 <memset>
  p->context->eip = (uint)forkret;
8010386b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103871:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103878:	89 d8                	mov    %ebx,%eax
8010387a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387d:	c9                   	leave  
8010387e:	c3                   	ret    
8010387f:	90                   	nop
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 c0 d6 14 80       	push   $0x8014d6c0
8010388a:	e8 e1 0d 00 00       	call   80104670 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ba:	68 c0 d6 14 80       	push   $0x8014d6c0
801038bf:	e8 ac 0d 00 00       	call   80104670 <release>

  if (first) {
801038c4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	85 c0                	test   %eax,%eax
801038ce:	75 08                	jne    801038d8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038d0:	c9                   	leave  
801038d1:	c3                   	ret    
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038d8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038df:	00 00 00 
    iinit(ROOTDEV);
801038e2:	83 ec 0c             	sub    $0xc,%esp
801038e5:	6a 01                	push   $0x1
801038e7:	e8 54 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038f3:	e8 e8 f3 ff ff       	call   80102ce0 <initlog>
}
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	c9                   	leave  
801038fc:	c3                   	ret    
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <pinit>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010390a:	68 80 76 10 80       	push   $0x80107680
8010390f:	68 c0 d6 14 80       	push   $0x8014d6c0
80103914:	e8 17 0b 00 00       	call   80104430 <initlock>
}
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax

80103920 <mycpu>:
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	56                   	push   %esi
80103928:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103929:	9c                   	pushf  
8010392a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010392b:	f6 c4 02             	test   $0x2,%ah
8010392e:	75 4a                	jne    8010397a <mycpu+0x5a>
  apicid = lapicid();
80103930:	e8 bb ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103935:	8b 35 a0 d6 14 80    	mov    0x8014d6a0,%esi
  apicid = lapicid();
8010393b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010393d:	85 f6                	test   %esi,%esi
8010393f:	7e 2c                	jle    8010396d <mycpu+0x4d>
80103941:	31 d2                	xor    %edx,%edx
80103943:	eb 0a                	jmp    8010394f <mycpu+0x2f>
80103945:	8d 76 00             	lea    0x0(%esi),%esi
80103948:	83 c2 01             	add    $0x1,%edx
8010394b:	39 f2                	cmp    %esi,%edx
8010394d:	74 1e                	je     8010396d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010394f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103955:	0f b6 81 20 d1 14 80 	movzbl -0x7feb2ee0(%ecx),%eax
8010395c:	39 d8                	cmp    %ebx,%eax
8010395e:	75 e8                	jne    80103948 <mycpu+0x28>
}
80103960:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103963:	8d 81 20 d1 14 80    	lea    -0x7feb2ee0(%ecx),%eax
}
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5d                   	pop    %ebp
8010396c:	c3                   	ret    
  panic("unknown apicid\n");
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 87 76 10 80       	push   $0x80107687
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 64 77 10 80       	push   $0x80107764
80103982:	e8 09 ca ff ff       	call   80100390 <panic>
80103987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398e:	66 90                	xchg   %ax,%ax

80103990 <cpuid>:
cpuid() {
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010399a:	e8 81 ff ff ff       	call   80103920 <mycpu>
}
8010399f:	c9                   	leave  
  return mycpu()-cpus;
801039a0:	2d 20 d1 14 80       	sub    $0x8014d120,%eax
801039a5:	c1 f8 04             	sar    $0x4,%eax
801039a8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ae:	c3                   	ret    
801039af:	90                   	nop

801039b0 <myproc>:
myproc(void) {
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039bb:	e8 f0 0a 00 00       	call   801044b0 <pushcli>
  c = mycpu();
801039c0:	e8 5b ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039c5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039cb:	e8 30 0b 00 00       	call   80104500 <popcli>
}
801039d0:	83 c4 04             	add    $0x4,%esp
801039d3:	89 d8                	mov    %ebx,%eax
801039d5:	5b                   	pop    %ebx
801039d6:	5d                   	pop    %ebp
801039d7:	c3                   	ret    
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <userinit>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039eb:	e8 f0 fd ff ff       	call   801037e0 <allocproc>
801039f0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039f2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039f7:	e8 a4 34 00 00       	call   80106ea0 <setupkvm>
801039fc:	89 43 04             	mov    %eax,0x4(%ebx)
801039ff:	85 c0                	test   %eax,%eax
80103a01:	0f 84 bd 00 00 00    	je     80103ac4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a07:	83 ec 04             	sub    $0x4,%esp
80103a0a:	68 2c 00 00 00       	push   $0x2c
80103a0f:	68 60 a4 10 80       	push   $0x8010a460
80103a14:	50                   	push   %eax
80103a15:	e8 56 31 00 00       	call   80106b70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a23:	6a 4c                	push   $0x4c
80103a25:	6a 00                	push   $0x0
80103a27:	ff 73 18             	pushl  0x18(%ebx)
80103a2a:	e8 91 0c 00 00       	call   801046c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a43:	8b 43 18             	mov    0x18(%ebx),%eax
80103a46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a55:	8b 43 18             	mov    0x18(%ebx),%eax
80103a58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a60:	8b 43 18             	mov    0x18(%ebx),%eax
80103a63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a74:	8b 43 18             	mov    0x18(%ebx),%eax
80103a77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a81:	6a 10                	push   $0x10
80103a83:	68 b0 76 10 80       	push   $0x801076b0
80103a88:	50                   	push   %eax
80103a89:	e8 f2 0d 00 00       	call   80104880 <safestrcpy>
  p->cwd = namei("/");
80103a8e:	c7 04 24 b9 76 10 80 	movl   $0x801076b9,(%esp)
80103a95:	e8 96 e5 ff ff       	call   80102030 <namei>
80103a9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a9d:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103aa4:	e8 07 0b 00 00       	call   801045b0 <acquire>
  p->state = RUNNABLE;
80103aa9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ab0:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103ab7:	e8 b4 0b 00 00       	call   80104670 <release>
}
80103abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	c9                   	leave  
80103ac3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac4:	83 ec 0c             	sub    $0xc,%esp
80103ac7:	68 97 76 10 80       	push   $0x80107697
80103acc:	e8 bf c8 ff ff       	call   80100390 <panic>
80103ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <growproc>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
80103ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aec:	e8 bf 09 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103af1:	e8 2a fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103af6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103afc:	e8 ff 09 00 00       	call   80104500 <popcli>
  sz = curproc->sz;
80103b01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b03:	85 f6                	test   %esi,%esi
80103b05:	7f 19                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b07:	75 37                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0e:	53                   	push   %ebx
80103b0f:	e8 4c 2f 00 00       	call   80106a60 <switchuvm>
  return 0;
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	31 c0                	xor    %eax,%eax
}
80103b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 91 31 00 00       	call   80106cc0 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 d3                	jne    80103b09 <growproc+0x29>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb dc                	jmp    80103b19 <growproc+0x39>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	pushl  0x4(%ebx)
80103b4a:	e8 a1 32 00 00       	call   80106df0 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 b3                	jne    80103b09 <growproc+0x29>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <fork>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	57                   	push   %edi
80103b68:	56                   	push   %esi
80103b69:	53                   	push   %ebx
80103b6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b6d:	e8 3e 09 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103b72:	e8 a9 fd ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103b77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b7d:	e8 7e 09 00 00       	call   80104500 <popcli>
  if((np = allocproc()) == 0){
80103b82:	e8 59 fc ff ff       	call   801037e0 <allocproc>
80103b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	0f 84 bb 00 00 00    	je     80103c4d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	ff 33                	pushl  (%ebx)
80103b97:	89 c7                	mov    %eax,%edi
80103b99:	ff 73 04             	pushl  0x4(%ebx)
80103b9c:	e8 cf 33 00 00       	call   80106f70 <copyuvm>
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	89 47 04             	mov    %eax,0x4(%edi)
80103ba7:	85 c0                	test   %eax,%eax
80103ba9:	0f 84 a5 00 00 00    	je     80103c54 <fork+0xf4>
  np->sz = curproc->sz;
80103baf:	8b 03                	mov    (%ebx),%eax
80103bb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bb6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bb9:	89 c8                	mov    %ecx,%eax
80103bbb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bbe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bc3:	8b 73 18             	mov    0x18(%ebx),%esi
80103bc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bc8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bca:	8b 40 18             	mov    0x18(%eax),%eax
80103bcd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103bd8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bdc:	85 c0                	test   %eax,%eax
80103bde:	74 13                	je     80103bf3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	50                   	push   %eax
80103be4:	e8 87 d2 ff ff       	call   80100e70 <filedup>
80103be9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bec:	83 c4 10             	add    $0x10,%esp
80103bef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bf3:	83 c6 01             	add    $0x1,%esi
80103bf6:	83 fe 10             	cmp    $0x10,%esi
80103bf9:	75 dd                	jne    80103bd8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bfb:	83 ec 0c             	sub    $0xc,%esp
80103bfe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c01:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c04:	e8 27 db ff ff       	call   80101730 <idup>
80103c09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c0c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c0f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c12:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c15:	6a 10                	push   $0x10
80103c17:	53                   	push   %ebx
80103c18:	50                   	push   %eax
80103c19:	e8 62 0c 00 00       	call   80104880 <safestrcpy>
  pid = np->pid;
80103c1e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c21:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103c28:	e8 83 09 00 00       	call   801045b0 <acquire>
  np->state = RUNNABLE;
80103c2d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c34:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103c3b:	e8 30 0a 00 00       	call   80104670 <release>
  return pid;
80103c40:	83 c4 10             	add    $0x10,%esp
}
80103c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c46:	89 d8                	mov    %ebx,%eax
80103c48:	5b                   	pop    %ebx
80103c49:	5e                   	pop    %esi
80103c4a:	5f                   	pop    %edi
80103c4b:	5d                   	pop    %ebp
80103c4c:	c3                   	ret    
    return -1;
80103c4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c52:	eb ef                	jmp    80103c43 <fork+0xe3>
    kfree(np->kstack);
80103c54:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	ff 73 08             	pushl  0x8(%ebx)
80103c5d:	e8 0e e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c69:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c78:	eb c9                	jmp    80103c43 <fork+0xe3>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c80 <scheduler>:
{
80103c80:	f3 0f 1e fb          	endbr32 
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	57                   	push   %edi
80103c88:	56                   	push   %esi
80103c89:	53                   	push   %ebx
80103c8a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c8d:	e8 8e fc ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103c92:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c99:	00 00 00 
  struct cpu *c = mycpu();
80103c9c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c9e:	8d 78 04             	lea    0x4(%eax),%edi
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103ca8:	fb                   	sti    
    acquire(&ptable.lock);
80103ca9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cac:	bb f4 d6 14 80       	mov    $0x8014d6f4,%ebx
    acquire(&ptable.lock);
80103cb1:	68 c0 d6 14 80       	push   $0x8014d6c0
80103cb6:	e8 f5 08 00 00       	call   801045b0 <acquire>
80103cbb:	83 c4 10             	add    $0x10,%esp
80103cbe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103cc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cc4:	75 33                	jne    80103cf9 <scheduler+0x79>
      switchuvm(p);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ccf:	53                   	push   %ebx
80103cd0:	e8 8b 2d 00 00       	call   80106a60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cd5:	58                   	pop    %eax
80103cd6:	5a                   	pop    %edx
80103cd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103cda:	57                   	push   %edi
      p->state = RUNNING;
80103cdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ce2:	e8 fc 0b 00 00       	call   801048e3 <swtch>
      switchkvm();
80103ce7:	e8 54 2d 00 00       	call   80106a40 <switchkvm>
      c->proc = 0;
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	83 c3 7c             	add    $0x7c,%ebx
80103cfc:	81 fb f4 f5 14 80    	cmp    $0x8014f5f4,%ebx
80103d02:	75 bc                	jne    80103cc0 <scheduler+0x40>
    release(&ptable.lock);
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	68 c0 d6 14 80       	push   $0x8014d6c0
80103d0c:	e8 5f 09 00 00       	call   80104670 <release>
    sti();
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	eb 92                	jmp    80103ca8 <scheduler+0x28>
80103d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <sched>:
{
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	56                   	push   %esi
80103d28:	53                   	push   %ebx
  pushcli();
80103d29:	e8 82 07 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103d2e:	e8 ed fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103d33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d39:	e8 c2 07 00 00       	call   80104500 <popcli>
  if(!holding(&ptable.lock))
80103d3e:	83 ec 0c             	sub    $0xc,%esp
80103d41:	68 c0 d6 14 80       	push   $0x8014d6c0
80103d46:	e8 15 08 00 00       	call   80104560 <holding>
80103d4b:	83 c4 10             	add    $0x10,%esp
80103d4e:	85 c0                	test   %eax,%eax
80103d50:	74 4f                	je     80103da1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d52:	e8 c9 fb ff ff       	call   80103920 <mycpu>
80103d57:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5e:	75 68                	jne    80103dc8 <sched+0xa8>
  if(p->state == RUNNING)
80103d60:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d64:	74 55                	je     80103dbb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d66:	9c                   	pushf  
80103d67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d68:	f6 c4 02             	test   $0x2,%ah
80103d6b:	75 41                	jne    80103dae <sched+0x8e>
  intena = mycpu()->intena;
80103d6d:	e8 ae fb ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d72:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d75:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d7b:	e8 a0 fb ff ff       	call   80103920 <mycpu>
80103d80:	83 ec 08             	sub    $0x8,%esp
80103d83:	ff 70 04             	pushl  0x4(%eax)
80103d86:	53                   	push   %ebx
80103d87:	e8 57 0b 00 00       	call   801048e3 <swtch>
  mycpu()->intena = intena;
80103d8c:	e8 8f fb ff ff       	call   80103920 <mycpu>
}
80103d91:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d94:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d9d:	5b                   	pop    %ebx
80103d9e:	5e                   	pop    %esi
80103d9f:	5d                   	pop    %ebp
80103da0:	c3                   	ret    
    panic("sched ptable.lock");
80103da1:	83 ec 0c             	sub    $0xc,%esp
80103da4:	68 bb 76 10 80       	push   $0x801076bb
80103da9:	e8 e2 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dae:	83 ec 0c             	sub    $0xc,%esp
80103db1:	68 e7 76 10 80       	push   $0x801076e7
80103db6:	e8 d5 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103dbb:	83 ec 0c             	sub    $0xc,%esp
80103dbe:	68 d9 76 10 80       	push   $0x801076d9
80103dc3:	e8 c8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	68 cd 76 10 80       	push   $0x801076cd
80103dd0:	e8 bb c5 ff ff       	call   80100390 <panic>
80103dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103de0 <exit>:
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	57                   	push   %edi
80103de8:	56                   	push   %esi
80103de9:	53                   	push   %ebx
80103dea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ded:	e8 be 06 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103df2:	e8 29 fb ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103df7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dfd:	e8 fe 06 00 00       	call   80104500 <popcli>
  if(curproc == initproc)
80103e02:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e05:	8d 7e 68             	lea    0x68(%esi),%edi
80103e08:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e0e:	0f 84 f3 00 00 00    	je     80103f07 <exit+0x127>
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e18:	8b 03                	mov    (%ebx),%eax
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 12                	je     80103e30 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	50                   	push   %eax
80103e22:	e8 99 d0 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103e27:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e30:	83 c3 04             	add    $0x4,%ebx
80103e33:	39 df                	cmp    %ebx,%edi
80103e35:	75 e1                	jne    80103e18 <exit+0x38>
  begin_op();
80103e37:	e8 44 ef ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	ff 76 68             	pushl  0x68(%esi)
80103e42:	e8 49 da ff ff       	call   80101890 <iput>
  end_op();
80103e47:	e8 a4 ef ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80103e4c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e53:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103e5a:	e8 51 07 00 00       	call   801045b0 <acquire>
  wakeup1(curproc->parent);
80103e5f:	8b 56 14             	mov    0x14(%esi),%edx
80103e62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e65:	b8 f4 d6 14 80       	mov    $0x8014d6f4,%eax
80103e6a:	eb 0e                	jmp    80103e7a <exit+0x9a>
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e70:	83 c0 7c             	add    $0x7c,%eax
80103e73:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
80103e78:	74 1c                	je     80103e96 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <exit+0x90>
80103e80:	3b 50 20             	cmp    0x20(%eax),%edx
80103e83:	75 eb                	jne    80103e70 <exit+0x90>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	83 c0 7c             	add    $0x7c,%eax
80103e8f:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
80103e94:	75 e4                	jne    80103e7a <exit+0x9a>
      p->parent = initproc;
80103e96:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e9c:	ba f4 d6 14 80       	mov    $0x8014d6f4,%edx
80103ea1:	eb 10                	jmp    80103eb3 <exit+0xd3>
80103ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea7:	90                   	nop
80103ea8:	83 c2 7c             	add    $0x7c,%edx
80103eab:	81 fa f4 f5 14 80    	cmp    $0x8014f5f4,%edx
80103eb1:	74 3b                	je     80103eee <exit+0x10e>
    if(p->parent == curproc){
80103eb3:	39 72 14             	cmp    %esi,0x14(%edx)
80103eb6:	75 f0                	jne    80103ea8 <exit+0xc8>
      if(p->state == ZOMBIE)
80103eb8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ebc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ebf:	75 e7                	jne    80103ea8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec1:	b8 f4 d6 14 80       	mov    $0x8014d6f4,%eax
80103ec6:	eb 12                	jmp    80103eda <exit+0xfa>
80103ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop
80103ed0:	83 c0 7c             	add    $0x7c,%eax
80103ed3:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
80103ed8:	74 ce                	je     80103ea8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <exit+0xf0>
80103ee0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ee3:	75 eb                	jne    80103ed0 <exit+0xf0>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eec:	eb e2                	jmp    80103ed0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103eee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ef5:	e8 26 fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 08 77 10 80       	push   $0x80107708
80103f02:	e8 89 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	68 fb 76 10 80       	push   $0x801076fb
80103f0f:	e8 7c c4 ff ff       	call   80100390 <panic>
80103f14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f1f:	90                   	nop

80103f20 <yield>:
{
80103f20:	f3 0f 1e fb          	endbr32 
80103f24:	55                   	push   %ebp
80103f25:	89 e5                	mov    %esp,%ebp
80103f27:	53                   	push   %ebx
80103f28:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f2b:	68 c0 d6 14 80       	push   $0x8014d6c0
80103f30:	e8 7b 06 00 00       	call   801045b0 <acquire>
  pushcli();
80103f35:	e8 76 05 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103f3a:	e8 e1 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f45:	e8 b6 05 00 00       	call   80104500 <popcli>
  myproc()->state = RUNNABLE;
80103f4a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f51:	e8 ca fd ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80103f56:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103f5d:	e8 0e 07 00 00       	call   80104670 <release>
}
80103f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	c9                   	leave  
80103f69:	c3                   	ret    
80103f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f70 <sleep>:
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	57                   	push   %edi
80103f78:	56                   	push   %esi
80103f79:	53                   	push   %ebx
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f80:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f83:	e8 28 05 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103f88:	e8 93 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f8d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f93:	e8 68 05 00 00       	call   80104500 <popcli>
  if(p == 0)
80103f98:	85 db                	test   %ebx,%ebx
80103f9a:	0f 84 83 00 00 00    	je     80104023 <sleep+0xb3>
  if(lk == 0)
80103fa0:	85 f6                	test   %esi,%esi
80103fa2:	74 72                	je     80104016 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fa4:	81 fe c0 d6 14 80    	cmp    $0x8014d6c0,%esi
80103faa:	74 4c                	je     80103ff8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 c0 d6 14 80       	push   $0x8014d6c0
80103fb4:	e8 f7 05 00 00       	call   801045b0 <acquire>
    release(lk);
80103fb9:	89 34 24             	mov    %esi,(%esp)
80103fbc:	e8 af 06 00 00       	call   80104670 <release>
  p->chan = chan;
80103fc1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fc4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fcb:	e8 50 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103fd0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fd7:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
80103fde:	e8 8d 06 00 00       	call   80104670 <release>
    acquire(lk);
80103fe3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fe6:	83 c4 10             	add    $0x10,%esp
}
80103fe9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fec:	5b                   	pop    %ebx
80103fed:	5e                   	pop    %esi
80103fee:	5f                   	pop    %edi
80103fef:	5d                   	pop    %ebp
    acquire(lk);
80103ff0:	e9 bb 05 00 00       	jmp    801045b0 <acquire>
80103ff5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103ff8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ffb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104002:	e8 19 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104007:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010400e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104011:	5b                   	pop    %ebx
80104012:	5e                   	pop    %esi
80104013:	5f                   	pop    %edi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
    panic("sleep without lk");
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 1a 77 10 80       	push   $0x8010771a
8010401e:	e8 6d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	68 14 77 10 80       	push   $0x80107714
8010402b:	e8 60 c3 ff ff       	call   80100390 <panic>

80104030 <wait>:
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	56                   	push   %esi
80104038:	53                   	push   %ebx
  pushcli();
80104039:	e8 72 04 00 00       	call   801044b0 <pushcli>
  c = mycpu();
8010403e:	e8 dd f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104043:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104049:	e8 b2 04 00 00       	call   80104500 <popcli>
  acquire(&ptable.lock);
8010404e:	83 ec 0c             	sub    $0xc,%esp
80104051:	68 c0 d6 14 80       	push   $0x8014d6c0
80104056:	e8 55 05 00 00       	call   801045b0 <acquire>
8010405b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010405e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104060:	bb f4 d6 14 80       	mov    $0x8014d6f4,%ebx
80104065:	eb 14                	jmp    8010407b <wait+0x4b>
80104067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406e:	66 90                	xchg   %ax,%ax
80104070:	83 c3 7c             	add    $0x7c,%ebx
80104073:	81 fb f4 f5 14 80    	cmp    $0x8014f5f4,%ebx
80104079:	74 1b                	je     80104096 <wait+0x66>
      if(p->parent != curproc)
8010407b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010407e:	75 f0                	jne    80104070 <wait+0x40>
      if(p->state == ZOMBIE){
80104080:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104084:	74 32                	je     801040b8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104086:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104089:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408e:	81 fb f4 f5 14 80    	cmp    $0x8014f5f4,%ebx
80104094:	75 e5                	jne    8010407b <wait+0x4b>
    if(!havekids || curproc->killed){
80104096:	85 c0                	test   %eax,%eax
80104098:	74 74                	je     8010410e <wait+0xde>
8010409a:	8b 46 24             	mov    0x24(%esi),%eax
8010409d:	85 c0                	test   %eax,%eax
8010409f:	75 6d                	jne    8010410e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040a1:	83 ec 08             	sub    $0x8,%esp
801040a4:	68 c0 d6 14 80       	push   $0x8014d6c0
801040a9:	56                   	push   %esi
801040aa:	e8 c1 fe ff ff       	call   80103f70 <sleep>
    havekids = 0;
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	eb aa                	jmp    8010405e <wait+0x2e>
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040be:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c1:	e8 aa e3 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801040c6:	5a                   	pop    %edx
801040c7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040ca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040d1:	e8 4a 2d 00 00       	call   80106e20 <freevm>
        release(&ptable.lock);
801040d6:	c7 04 24 c0 d6 14 80 	movl   $0x8014d6c0,(%esp)
        p->pid = 0;
801040dd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040e4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040eb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040ef:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040fd:	e8 6e 05 00 00       	call   80104670 <release>
        return pid;
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104108:	89 f0                	mov    %esi,%eax
8010410a:	5b                   	pop    %ebx
8010410b:	5e                   	pop    %esi
8010410c:	5d                   	pop    %ebp
8010410d:	c3                   	ret    
      release(&ptable.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104111:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104116:	68 c0 d6 14 80       	push   $0x8014d6c0
8010411b:	e8 50 05 00 00       	call   80104670 <release>
      return -1;
80104120:	83 c4 10             	add    $0x10,%esp
80104123:	eb e0                	jmp    80104105 <wait+0xd5>
80104125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	53                   	push   %ebx
80104138:	83 ec 10             	sub    $0x10,%esp
8010413b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413e:	68 c0 d6 14 80       	push   $0x8014d6c0
80104143:	e8 68 04 00 00       	call   801045b0 <acquire>
80104148:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414b:	b8 f4 d6 14 80       	mov    $0x8014d6f4,%eax
80104150:	eb 10                	jmp    80104162 <wakeup+0x32>
80104152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104158:	83 c0 7c             	add    $0x7c,%eax
8010415b:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
80104160:	74 1c                	je     8010417e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104162:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104166:	75 f0                	jne    80104158 <wakeup+0x28>
80104168:	3b 58 20             	cmp    0x20(%eax),%ebx
8010416b:	75 eb                	jne    80104158 <wakeup+0x28>
      p->state = RUNNABLE;
8010416d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104174:	83 c0 7c             	add    $0x7c,%eax
80104177:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
8010417c:	75 e4                	jne    80104162 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010417e:	c7 45 08 c0 d6 14 80 	movl   $0x8014d6c0,0x8(%ebp)
}
80104185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104188:	c9                   	leave  
  release(&ptable.lock);
80104189:	e9 e2 04 00 00       	jmp    80104670 <release>
8010418e:	66 90                	xchg   %ax,%ax

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	f3 0f 1e fb          	endbr32 
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	53                   	push   %ebx
80104198:	83 ec 10             	sub    $0x10,%esp
8010419b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419e:	68 c0 d6 14 80       	push   $0x8014d6c0
801041a3:	e8 08 04 00 00       	call   801045b0 <acquire>
801041a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ab:	b8 f4 d6 14 80       	mov    $0x8014d6f4,%eax
801041b0:	eb 10                	jmp    801041c2 <kill+0x32>
801041b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041b8:	83 c0 7c             	add    $0x7c,%eax
801041bb:	3d f4 f5 14 80       	cmp    $0x8014f5f4,%eax
801041c0:	74 36                	je     801041f8 <kill+0x68>
    if(p->pid == pid){
801041c2:	39 58 10             	cmp    %ebx,0x10(%eax)
801041c5:	75 f1                	jne    801041b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041c7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041d2:	75 07                	jne    801041db <kill+0x4b>
        p->state = RUNNABLE;
801041d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041db:	83 ec 0c             	sub    $0xc,%esp
801041de:	68 c0 d6 14 80       	push   $0x8014d6c0
801041e3:	e8 88 04 00 00       	call   80104670 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	31 c0                	xor    %eax,%eax
}
801041f0:	c9                   	leave  
801041f1:	c3                   	ret    
801041f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 c0 d6 14 80       	push   $0x8014d6c0
80104200:	e8 6b 04 00 00       	call   80104670 <release>
}
80104205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104210:	c9                   	leave  
80104211:	c3                   	ret    
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	57                   	push   %edi
80104228:	56                   	push   %esi
80104229:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010422c:	53                   	push   %ebx
8010422d:	bb 60 d7 14 80       	mov    $0x8014d760,%ebx
80104232:	83 ec 3c             	sub    $0x3c,%esp
80104235:	eb 28                	jmp    8010425f <procdump+0x3f>
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	68 97 7a 10 80       	push   $0x80107a97
80104248:	e8 63 c4 ff ff       	call   801006b0 <cprintf>
8010424d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104250:	83 c3 7c             	add    $0x7c,%ebx
80104253:	81 fb 60 f6 14 80    	cmp    $0x8014f660,%ebx
80104259:	0f 84 81 00 00 00    	je     801042e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010425f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104262:	85 c0                	test   %eax,%eax
80104264:	74 ea                	je     80104250 <procdump+0x30>
      state = "???";
80104266:	ba 2b 77 10 80       	mov    $0x8010772b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010426b:	83 f8 05             	cmp    $0x5,%eax
8010426e:	77 11                	ja     80104281 <procdump+0x61>
80104270:	8b 14 85 8c 77 10 80 	mov    -0x7fef8874(,%eax,4),%edx
      state = "???";
80104277:	b8 2b 77 10 80       	mov    $0x8010772b,%eax
8010427c:	85 d2                	test   %edx,%edx
8010427e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104281:	53                   	push   %ebx
80104282:	52                   	push   %edx
80104283:	ff 73 a4             	pushl  -0x5c(%ebx)
80104286:	68 2f 77 10 80       	push   $0x8010772f
8010428b:	e8 20 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104290:	83 c4 10             	add    $0x10,%esp
80104293:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104297:	75 a7                	jne    80104240 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104299:	83 ec 08             	sub    $0x8,%esp
8010429c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010429f:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042a2:	50                   	push   %eax
801042a3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042a6:	8b 40 0c             	mov    0xc(%eax),%eax
801042a9:	83 c0 08             	add    $0x8,%eax
801042ac:	50                   	push   %eax
801042ad:	e8 9e 01 00 00       	call   80104450 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b2:	83 c4 10             	add    $0x10,%esp
801042b5:	8d 76 00             	lea    0x0(%esi),%esi
801042b8:	8b 17                	mov    (%edi),%edx
801042ba:	85 d2                	test   %edx,%edx
801042bc:	74 82                	je     80104240 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042be:	83 ec 08             	sub    $0x8,%esp
801042c1:	83 c7 04             	add    $0x4,%edi
801042c4:	52                   	push   %edx
801042c5:	68 81 71 10 80       	push   $0x80107181
801042ca:	e8 e1 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	39 fe                	cmp    %edi,%esi
801042d4:	75 e2                	jne    801042b8 <procdump+0x98>
801042d6:	e9 65 ff ff ff       	jmp    80104240 <procdump+0x20>
801042db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042df:	90                   	nop
  }
}
801042e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e3:	5b                   	pop    %ebx
801042e4:	5e                   	pop    %esi
801042e5:	5f                   	pop    %edi
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    
801042e8:	66 90                	xchg   %ax,%ax
801042ea:	66 90                	xchg   %ax,%ax
801042ec:	66 90                	xchg   %ax,%ax
801042ee:	66 90                	xchg   %ax,%ax

801042f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	53                   	push   %ebx
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042fe:	68 a4 77 10 80       	push   $0x801077a4
80104303:	8d 43 04             	lea    0x4(%ebx),%eax
80104306:	50                   	push   %eax
80104307:	e8 24 01 00 00       	call   80104430 <initlock>
  lk->name = name;
8010430c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010430f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104315:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104318:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010431f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104325:	c9                   	leave  
80104326:	c3                   	ret    
80104327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432e:	66 90                	xchg   %ax,%ax

80104330 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
80104339:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010433c:	8d 73 04             	lea    0x4(%ebx),%esi
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	56                   	push   %esi
80104343:	e8 68 02 00 00       	call   801045b0 <acquire>
  while (lk->locked) {
80104348:	8b 13                	mov    (%ebx),%edx
8010434a:	83 c4 10             	add    $0x10,%esp
8010434d:	85 d2                	test   %edx,%edx
8010434f:	74 1a                	je     8010436b <acquiresleep+0x3b>
80104351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	56                   	push   %esi
8010435c:	53                   	push   %ebx
8010435d:	e8 0e fc ff ff       	call   80103f70 <sleep>
  while (lk->locked) {
80104362:	8b 03                	mov    (%ebx),%eax
80104364:	83 c4 10             	add    $0x10,%esp
80104367:	85 c0                	test   %eax,%eax
80104369:	75 ed                	jne    80104358 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010436b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104371:	e8 3a f6 ff ff       	call   801039b0 <myproc>
80104376:	8b 40 10             	mov    0x10(%eax),%eax
80104379:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010437c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010437f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
  release(&lk->lk);
80104385:	e9 e6 02 00 00       	jmp    80104670 <release>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	56                   	push   %esi
80104398:	53                   	push   %ebx
80104399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010439c:	8d 73 04             	lea    0x4(%ebx),%esi
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	56                   	push   %esi
801043a3:	e8 08 02 00 00       	call   801045b0 <acquire>
  lk->locked = 0;
801043a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043b5:	89 1c 24             	mov    %ebx,(%esp)
801043b8:	e8 73 fd ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
801043bd:	89 75 08             	mov    %esi,0x8(%ebp)
801043c0:	83 c4 10             	add    $0x10,%esp
}
801043c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c6:	5b                   	pop    %ebx
801043c7:	5e                   	pop    %esi
801043c8:	5d                   	pop    %ebp
  release(&lk->lk);
801043c9:	e9 a2 02 00 00       	jmp    80104670 <release>
801043ce:	66 90                	xchg   %ax,%ax

801043d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	57                   	push   %edi
801043d8:	31 ff                	xor    %edi,%edi
801043da:	56                   	push   %esi
801043db:	53                   	push   %ebx
801043dc:	83 ec 18             	sub    $0x18,%esp
801043df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043e2:	8d 73 04             	lea    0x4(%ebx),%esi
801043e5:	56                   	push   %esi
801043e6:	e8 c5 01 00 00       	call   801045b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043eb:	8b 03                	mov    (%ebx),%eax
801043ed:	83 c4 10             	add    $0x10,%esp
801043f0:	85 c0                	test   %eax,%eax
801043f2:	75 1c                	jne    80104410 <holdingsleep+0x40>
  release(&lk->lk);
801043f4:	83 ec 0c             	sub    $0xc,%esp
801043f7:	56                   	push   %esi
801043f8:	e8 73 02 00 00       	call   80104670 <release>
  return r;
}
801043fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104400:	89 f8                	mov    %edi,%eax
80104402:	5b                   	pop    %ebx
80104403:	5e                   	pop    %esi
80104404:	5f                   	pop    %edi
80104405:	5d                   	pop    %ebp
80104406:	c3                   	ret    
80104407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104410:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104413:	e8 98 f5 ff ff       	call   801039b0 <myproc>
80104418:	39 58 10             	cmp    %ebx,0x10(%eax)
8010441b:	0f 94 c0             	sete   %al
8010441e:	0f b6 c0             	movzbl %al,%eax
80104421:	89 c7                	mov    %eax,%edi
80104423:	eb cf                	jmp    801043f4 <holdingsleep+0x24>
80104425:	66 90                	xchg   %ax,%ax
80104427:	66 90                	xchg   %ax,%ax
80104429:	66 90                	xchg   %ax,%ax
8010442b:	66 90                	xchg   %ax,%ax
8010442d:	66 90                	xchg   %ax,%ax
8010442f:	90                   	nop

80104430 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104430:	f3 0f 1e fb          	endbr32 
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010443a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010443d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104443:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104446:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010444d:	5d                   	pop    %ebp
8010444e:	c3                   	ret    
8010444f:	90                   	nop

80104450 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104455:	31 d2                	xor    %edx,%edx
{
80104457:	89 e5                	mov    %esp,%ebp
80104459:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010445a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010445d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104460:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104468:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010446e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104474:	77 1a                	ja     80104490 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104476:	8b 58 04             	mov    0x4(%eax),%ebx
80104479:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010447c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010447f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104481:	83 fa 0a             	cmp    $0xa,%edx
80104484:	75 e2                	jne    80104468 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104486:	5b                   	pop    %ebx
80104487:	5d                   	pop    %ebp
80104488:	c3                   	ret    
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104490:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104493:	8d 51 28             	lea    0x28(%ecx),%edx
80104496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801044a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044a6:	83 c0 04             	add    $0x4,%eax
801044a9:	39 d0                	cmp    %edx,%eax
801044ab:	75 f3                	jne    801044a0 <getcallerpcs+0x50>
}
801044ad:	5b                   	pop    %ebx
801044ae:	5d                   	pop    %ebp
801044af:	c3                   	ret    

801044b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	53                   	push   %ebx
801044b8:	83 ec 04             	sub    $0x4,%esp
801044bb:	9c                   	pushf  
801044bc:	5b                   	pop    %ebx
  asm volatile("cli");
801044bd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044be:	e8 5d f4 ff ff       	call   80103920 <mycpu>
801044c3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044c9:	85 c0                	test   %eax,%eax
801044cb:	74 13                	je     801044e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044cd:	e8 4e f4 ff ff       	call   80103920 <mycpu>
801044d2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044d9:	83 c4 04             	add    $0x4,%esp
801044dc:	5b                   	pop    %ebx
801044dd:	5d                   	pop    %ebp
801044de:	c3                   	ret    
801044df:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044e0:	e8 3b f4 ff ff       	call   80103920 <mycpu>
801044e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044f1:	eb da                	jmp    801044cd <pushcli+0x1d>
801044f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <popcli>:

void
popcli(void)
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010450a:	9c                   	pushf  
8010450b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010450c:	f6 c4 02             	test   $0x2,%ah
8010450f:	75 31                	jne    80104542 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104511:	e8 0a f4 ff ff       	call   80103920 <mycpu>
80104516:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010451d:	78 30                	js     8010454f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010451f:	e8 fc f3 ff ff       	call   80103920 <mycpu>
80104524:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010452a:	85 d2                	test   %edx,%edx
8010452c:	74 02                	je     80104530 <popcli+0x30>
    sti();
}
8010452e:	c9                   	leave  
8010452f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104530:	e8 eb f3 ff ff       	call   80103920 <mycpu>
80104535:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010453b:	85 c0                	test   %eax,%eax
8010453d:	74 ef                	je     8010452e <popcli+0x2e>
  asm volatile("sti");
8010453f:	fb                   	sti    
}
80104540:	c9                   	leave  
80104541:	c3                   	ret    
    panic("popcli - interruptible");
80104542:	83 ec 0c             	sub    $0xc,%esp
80104545:	68 af 77 10 80       	push   $0x801077af
8010454a:	e8 41 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 c6 77 10 80       	push   $0x801077c6
80104557:	e8 34 be ff ff       	call   80100390 <panic>
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <holding>:
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	53                   	push   %ebx
80104569:	8b 75 08             	mov    0x8(%ebp),%esi
8010456c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010456e:	e8 3d ff ff ff       	call   801044b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104573:	8b 06                	mov    (%esi),%eax
80104575:	85 c0                	test   %eax,%eax
80104577:	75 0f                	jne    80104588 <holding+0x28>
  popcli();
80104579:	e8 82 ff ff ff       	call   80104500 <popcli>
}
8010457e:	89 d8                	mov    %ebx,%eax
80104580:	5b                   	pop    %ebx
80104581:	5e                   	pop    %esi
80104582:	5d                   	pop    %ebp
80104583:	c3                   	ret    
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104588:	8b 5e 08             	mov    0x8(%esi),%ebx
8010458b:	e8 90 f3 ff ff       	call   80103920 <mycpu>
80104590:	39 c3                	cmp    %eax,%ebx
80104592:	0f 94 c3             	sete   %bl
  popcli();
80104595:	e8 66 ff ff ff       	call   80104500 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010459a:	0f b6 db             	movzbl %bl,%ebx
}
8010459d:	89 d8                	mov    %ebx,%eax
8010459f:	5b                   	pop    %ebx
801045a0:	5e                   	pop    %esi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <acquire>:
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	56                   	push   %esi
801045b8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045b9:	e8 f2 fe ff ff       	call   801044b0 <pushcli>
  if(holding(lk))
801045be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c1:	83 ec 0c             	sub    $0xc,%esp
801045c4:	53                   	push   %ebx
801045c5:	e8 96 ff ff ff       	call   80104560 <holding>
801045ca:	83 c4 10             	add    $0x10,%esp
801045cd:	85 c0                	test   %eax,%eax
801045cf:	0f 85 7f 00 00 00    	jne    80104654 <acquire+0xa4>
801045d5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801045d7:	ba 01 00 00 00       	mov    $0x1,%edx
801045dc:	eb 05                	jmp    801045e3 <acquire+0x33>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045e3:	89 d0                	mov    %edx,%eax
801045e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045e8:	85 c0                	test   %eax,%eax
801045ea:	75 f4                	jne    801045e0 <acquire+0x30>
  __sync_synchronize();
801045ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045f4:	e8 27 f3 ff ff       	call   80103920 <mycpu>
801045f9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045fc:	89 e8                	mov    %ebp,%eax
801045fe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104600:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104606:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010460c:	77 22                	ja     80104630 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010460e:	8b 50 04             	mov    0x4(%eax),%edx
80104611:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104615:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104618:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010461a:	83 fe 0a             	cmp    $0xa,%esi
8010461d:	75 e1                	jne    80104600 <acquire+0x50>
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
80104626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104630:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104634:	83 c3 34             	add    $0x34,%ebx
80104637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104646:	83 c0 04             	add    $0x4,%eax
80104649:	39 d8                	cmp    %ebx,%eax
8010464b:	75 f3                	jne    80104640 <acquire+0x90>
}
8010464d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
    panic("acquire");
80104654:	83 ec 0c             	sub    $0xc,%esp
80104657:	68 cd 77 10 80       	push   $0x801077cd
8010465c:	e8 2f bd ff ff       	call   80100390 <panic>
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <release>:
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	53                   	push   %ebx
80104678:	83 ec 10             	sub    $0x10,%esp
8010467b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010467e:	53                   	push   %ebx
8010467f:	e8 dc fe ff ff       	call   80104560 <holding>
80104684:	83 c4 10             	add    $0x10,%esp
80104687:	85 c0                	test   %eax,%eax
80104689:	74 22                	je     801046ad <release+0x3d>
  lk->pcs[0] = 0;
8010468b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104692:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104699:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010469e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a7:	c9                   	leave  
  popcli();
801046a8:	e9 53 fe ff ff       	jmp    80104500 <popcli>
    panic("release");
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	68 d5 77 10 80       	push   $0x801077d5
801046b5:	e8 d6 bc ff ff       	call   80100390 <panic>
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	57                   	push   %edi
801046c8:	8b 55 08             	mov    0x8(%ebp),%edx
801046cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046ce:	53                   	push   %ebx
801046cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046d2:	89 d7                	mov    %edx,%edi
801046d4:	09 cf                	or     %ecx,%edi
801046d6:	83 e7 03             	and    $0x3,%edi
801046d9:	75 25                	jne    80104700 <memset+0x40>
    c &= 0xFF;
801046db:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046de:	c1 e0 18             	shl    $0x18,%eax
801046e1:	89 fb                	mov    %edi,%ebx
801046e3:	c1 e9 02             	shr    $0x2,%ecx
801046e6:	c1 e3 10             	shl    $0x10,%ebx
801046e9:	09 d8                	or     %ebx,%eax
801046eb:	09 f8                	or     %edi,%eax
801046ed:	c1 e7 08             	shl    $0x8,%edi
801046f0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046f2:	89 d7                	mov    %edx,%edi
801046f4:	fc                   	cld    
801046f5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046f7:	5b                   	pop    %ebx
801046f8:	89 d0                	mov    %edx,%eax
801046fa:	5f                   	pop    %edi
801046fb:	5d                   	pop    %ebp
801046fc:	c3                   	ret    
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104700:	89 d7                	mov    %edx,%edi
80104702:	fc                   	cld    
80104703:	f3 aa                	rep stos %al,%es:(%edi)
80104705:	5b                   	pop    %ebx
80104706:	89 d0                	mov    %edx,%eax
80104708:	5f                   	pop    %edi
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	56                   	push   %esi
80104718:	8b 75 10             	mov    0x10(%ebp),%esi
8010471b:	8b 55 08             	mov    0x8(%ebp),%edx
8010471e:	53                   	push   %ebx
8010471f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104722:	85 f6                	test   %esi,%esi
80104724:	74 2a                	je     80104750 <memcmp+0x40>
80104726:	01 c6                	add    %eax,%esi
80104728:	eb 10                	jmp    8010473a <memcmp+0x2a>
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104736:	39 f0                	cmp    %esi,%eax
80104738:	74 16                	je     80104750 <memcmp+0x40>
    if(*s1 != *s2)
8010473a:	0f b6 0a             	movzbl (%edx),%ecx
8010473d:	0f b6 18             	movzbl (%eax),%ebx
80104740:	38 d9                	cmp    %bl,%cl
80104742:	74 ec                	je     80104730 <memcmp+0x20>
      return *s1 - *s2;
80104744:	0f b6 c1             	movzbl %cl,%eax
80104747:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104749:	5b                   	pop    %ebx
8010474a:	5e                   	pop    %esi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
80104750:	5b                   	pop    %ebx
  return 0;
80104751:	31 c0                	xor    %eax,%eax
}
80104753:	5e                   	pop    %esi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi

80104760 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	57                   	push   %edi
80104768:	8b 55 08             	mov    0x8(%ebp),%edx
8010476b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010476e:	56                   	push   %esi
8010476f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104772:	39 d6                	cmp    %edx,%esi
80104774:	73 2a                	jae    801047a0 <memmove+0x40>
80104776:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104779:	39 fa                	cmp    %edi,%edx
8010477b:	73 23                	jae    801047a0 <memmove+0x40>
8010477d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104780:	85 c9                	test   %ecx,%ecx
80104782:	74 13                	je     80104797 <memmove+0x37>
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104788:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010478c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010478f:	83 e8 01             	sub    $0x1,%eax
80104792:	83 f8 ff             	cmp    $0xffffffff,%eax
80104795:	75 f1                	jne    80104788 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104797:	5e                   	pop    %esi
80104798:	89 d0                	mov    %edx,%eax
8010479a:	5f                   	pop    %edi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801047a0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047a3:	89 d7                	mov    %edx,%edi
801047a5:	85 c9                	test   %ecx,%ecx
801047a7:	74 ee                	je     80104797 <memmove+0x37>
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047b1:	39 f0                	cmp    %esi,%eax
801047b3:	75 fb                	jne    801047b0 <memmove+0x50>
}
801047b5:	5e                   	pop    %esi
801047b6:	89 d0                	mov    %edx,%eax
801047b8:	5f                   	pop    %edi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop

801047c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047c0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801047c4:	eb 9a                	jmp    80104760 <memmove>
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047d0:	f3 0f 1e fb          	endbr32 
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	56                   	push   %esi
801047d8:	8b 75 10             	mov    0x10(%ebp),%esi
801047db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047de:	53                   	push   %ebx
801047df:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047e2:	85 f6                	test   %esi,%esi
801047e4:	74 32                	je     80104818 <strncmp+0x48>
801047e6:	01 c6                	add    %eax,%esi
801047e8:	eb 14                	jmp    801047fe <strncmp+0x2e>
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f0:	38 da                	cmp    %bl,%dl
801047f2:	75 14                	jne    80104808 <strncmp+0x38>
    n--, p++, q++;
801047f4:	83 c0 01             	add    $0x1,%eax
801047f7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047fa:	39 f0                	cmp    %esi,%eax
801047fc:	74 1a                	je     80104818 <strncmp+0x48>
801047fe:	0f b6 11             	movzbl (%ecx),%edx
80104801:	0f b6 18             	movzbl (%eax),%ebx
80104804:	84 d2                	test   %dl,%dl
80104806:	75 e8                	jne    801047f0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104808:	0f b6 c2             	movzbl %dl,%eax
8010480b:	29 d8                	sub    %ebx,%eax
}
8010480d:	5b                   	pop    %ebx
8010480e:	5e                   	pop    %esi
8010480f:	5d                   	pop    %ebp
80104810:	c3                   	ret    
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104818:	5b                   	pop    %ebx
    return 0;
80104819:	31 c0                	xor    %eax,%eax
}
8010481b:	5e                   	pop    %esi
8010481c:	5d                   	pop    %ebp
8010481d:	c3                   	ret    
8010481e:	66 90                	xchg   %ax,%ax

80104820 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	57                   	push   %edi
80104828:	56                   	push   %esi
80104829:	8b 75 08             	mov    0x8(%ebp),%esi
8010482c:	53                   	push   %ebx
8010482d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104830:	89 f2                	mov    %esi,%edx
80104832:	eb 1b                	jmp    8010484f <strncpy+0x2f>
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104838:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010483c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010483f:	83 c2 01             	add    $0x1,%edx
80104842:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104846:	89 f9                	mov    %edi,%ecx
80104848:	88 4a ff             	mov    %cl,-0x1(%edx)
8010484b:	84 c9                	test   %cl,%cl
8010484d:	74 09                	je     80104858 <strncpy+0x38>
8010484f:	89 c3                	mov    %eax,%ebx
80104851:	83 e8 01             	sub    $0x1,%eax
80104854:	85 db                	test   %ebx,%ebx
80104856:	7f e0                	jg     80104838 <strncpy+0x18>
    ;
  while(n-- > 0)
80104858:	89 d1                	mov    %edx,%ecx
8010485a:	85 c0                	test   %eax,%eax
8010485c:	7e 15                	jle    80104873 <strncpy+0x53>
8010485e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104860:	83 c1 01             	add    $0x1,%ecx
80104863:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104867:	89 c8                	mov    %ecx,%eax
80104869:	f7 d0                	not    %eax
8010486b:	01 d0                	add    %edx,%eax
8010486d:	01 d8                	add    %ebx,%eax
8010486f:	85 c0                	test   %eax,%eax
80104871:	7f ed                	jg     80104860 <strncpy+0x40>
  return os;
}
80104873:	5b                   	pop    %ebx
80104874:	89 f0                	mov    %esi,%eax
80104876:	5e                   	pop    %esi
80104877:	5f                   	pop    %edi
80104878:	5d                   	pop    %ebp
80104879:	c3                   	ret    
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104880:	f3 0f 1e fb          	endbr32 
80104884:	55                   	push   %ebp
80104885:	89 e5                	mov    %esp,%ebp
80104887:	56                   	push   %esi
80104888:	8b 55 10             	mov    0x10(%ebp),%edx
8010488b:	8b 75 08             	mov    0x8(%ebp),%esi
8010488e:	53                   	push   %ebx
8010488f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104892:	85 d2                	test   %edx,%edx
80104894:	7e 21                	jle    801048b7 <safestrcpy+0x37>
80104896:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010489a:	89 f2                	mov    %esi,%edx
8010489c:	eb 12                	jmp    801048b0 <safestrcpy+0x30>
8010489e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048a0:	0f b6 08             	movzbl (%eax),%ecx
801048a3:	83 c0 01             	add    $0x1,%eax
801048a6:	83 c2 01             	add    $0x1,%edx
801048a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048ac:	84 c9                	test   %cl,%cl
801048ae:	74 04                	je     801048b4 <safestrcpy+0x34>
801048b0:	39 d8                	cmp    %ebx,%eax
801048b2:	75 ec                	jne    801048a0 <safestrcpy+0x20>
    ;
  *s = 0;
801048b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048b7:	89 f0                	mov    %esi,%eax
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <strlen>:

int
strlen(const char *s)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048c5:	31 c0                	xor    %eax,%eax
{
801048c7:	89 e5                	mov    %esp,%ebp
801048c9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048cc:	80 3a 00             	cmpb   $0x0,(%edx)
801048cf:	74 10                	je     801048e1 <strlen+0x21>
801048d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d8:	83 c0 01             	add    $0x1,%eax
801048db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048df:	75 f7                	jne    801048d8 <strlen+0x18>
    ;
  return n;
}
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret    

801048e3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048e7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048eb:	55                   	push   %ebp
  pushl %ebx
801048ec:	53                   	push   %ebx
  pushl %esi
801048ed:	56                   	push   %esi
  pushl %edi
801048ee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048ef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048f1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048f3:	5f                   	pop    %edi
  popl %esi
801048f4:	5e                   	pop    %esi
  popl %ebx
801048f5:	5b                   	pop    %ebx
  popl %ebp
801048f6:	5d                   	pop    %ebp
  ret
801048f7:	c3                   	ret    
801048f8:	66 90                	xchg   %ax,%ax
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	53                   	push   %ebx
80104908:	83 ec 04             	sub    $0x4,%esp
8010490b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010490e:	e8 9d f0 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104913:	8b 00                	mov    (%eax),%eax
80104915:	39 d8                	cmp    %ebx,%eax
80104917:	76 17                	jbe    80104930 <fetchint+0x30>
80104919:	8d 53 04             	lea    0x4(%ebx),%edx
8010491c:	39 d0                	cmp    %edx,%eax
8010491e:	72 10                	jb     80104930 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104920:	8b 45 0c             	mov    0xc(%ebp),%eax
80104923:	8b 13                	mov    (%ebx),%edx
80104925:	89 10                	mov    %edx,(%eax)
  return 0;
80104927:	31 c0                	xor    %eax,%eax
}
80104929:	83 c4 04             	add    $0x4,%esp
8010492c:	5b                   	pop    %ebx
8010492d:	5d                   	pop    %ebp
8010492e:	c3                   	ret    
8010492f:	90                   	nop
    return -1;
80104930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104935:	eb f2                	jmp    80104929 <fetchint+0x29>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	53                   	push   %ebx
80104948:	83 ec 04             	sub    $0x4,%esp
8010494b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010494e:	e8 5d f0 ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
80104953:	39 18                	cmp    %ebx,(%eax)
80104955:	76 31                	jbe    80104988 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104957:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010495c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010495e:	39 d3                	cmp    %edx,%ebx
80104960:	73 26                	jae    80104988 <fetchstr+0x48>
80104962:	89 d8                	mov    %ebx,%eax
80104964:	eb 11                	jmp    80104977 <fetchstr+0x37>
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
80104970:	83 c0 01             	add    $0x1,%eax
80104973:	39 c2                	cmp    %eax,%edx
80104975:	76 11                	jbe    80104988 <fetchstr+0x48>
    if(*s == 0)
80104977:	80 38 00             	cmpb   $0x0,(%eax)
8010497a:	75 f4                	jne    80104970 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010497c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010497f:	29 d8                	sub    %ebx,%eax
}
80104981:	5b                   	pop    %ebx
80104982:	5d                   	pop    %ebp
80104983:	c3                   	ret    
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104988:	83 c4 04             	add    $0x4,%esp
    return -1;
8010498b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104990:	5b                   	pop    %ebx
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
80104993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	56                   	push   %esi
801049a8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a9:	e8 02 f0 ff ff       	call   801039b0 <myproc>
801049ae:	8b 55 08             	mov    0x8(%ebp),%edx
801049b1:	8b 40 18             	mov    0x18(%eax),%eax
801049b4:	8b 40 44             	mov    0x44(%eax),%eax
801049b7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049ba:	e8 f1 ef ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049bf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049c2:	8b 00                	mov    (%eax),%eax
801049c4:	39 c6                	cmp    %eax,%esi
801049c6:	73 18                	jae    801049e0 <argint+0x40>
801049c8:	8d 53 08             	lea    0x8(%ebx),%edx
801049cb:	39 d0                	cmp    %edx,%eax
801049cd:	72 11                	jb     801049e0 <argint+0x40>
  *ip = *(int*)(addr);
801049cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801049d2:	8b 53 04             	mov    0x4(%ebx),%edx
801049d5:	89 10                	mov    %edx,(%eax)
  return 0;
801049d7:	31 c0                	xor    %eax,%eax
}
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret    
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e5:	eb f2                	jmp    801049d9 <argint+0x39>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	56                   	push   %esi
801049f8:	53                   	push   %ebx
801049f9:	83 ec 10             	sub    $0x10,%esp
801049fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049ff:	e8 ac ef ff ff       	call   801039b0 <myproc>
 
  if(argint(n, &i) < 0)
80104a04:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a07:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a0c:	50                   	push   %eax
80104a0d:	ff 75 08             	pushl  0x8(%ebp)
80104a10:	e8 8b ff ff ff       	call   801049a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a15:	83 c4 10             	add    $0x10,%esp
80104a18:	85 c0                	test   %eax,%eax
80104a1a:	78 24                	js     80104a40 <argptr+0x50>
80104a1c:	85 db                	test   %ebx,%ebx
80104a1e:	78 20                	js     80104a40 <argptr+0x50>
80104a20:	8b 16                	mov    (%esi),%edx
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	39 c2                	cmp    %eax,%edx
80104a27:	76 17                	jbe    80104a40 <argptr+0x50>
80104a29:	01 c3                	add    %eax,%ebx
80104a2b:	39 da                	cmp    %ebx,%edx
80104a2d:	72 11                	jb     80104a40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a32:	89 02                	mov    %eax,(%edx)
  return 0;
80104a34:	31 c0                	xor    %eax,%eax
}
80104a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a45:	eb ef                	jmp    80104a36 <argptr+0x46>
80104a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4e:	66 90                	xchg   %ax,%ax

80104a50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a5d:	50                   	push   %eax
80104a5e:	ff 75 08             	pushl  0x8(%ebp)
80104a61:	e8 3a ff ff ff       	call   801049a0 <argint>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 c0                	test   %eax,%eax
80104a6b:	78 13                	js     80104a80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a6d:	83 ec 08             	sub    $0x8,%esp
80104a70:	ff 75 0c             	pushl  0xc(%ebp)
80104a73:	ff 75 f4             	pushl  -0xc(%ebp)
80104a76:	e8 c5 fe ff ff       	call   80104940 <fetchstr>
80104a7b:	83 c4 10             	add    $0x10,%esp
}
80104a7e:	c9                   	leave  
80104a7f:	c3                   	ret    
80104a80:	c9                   	leave  
    return -1;
80104a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a86:	c3                   	ret    
80104a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	53                   	push   %ebx
80104a98:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a9b:	e8 10 ef ff ff       	call   801039b0 <myproc>
80104aa0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104aa2:	8b 40 18             	mov    0x18(%eax),%eax
80104aa5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104aa8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104aab:	83 fa 14             	cmp    $0x14,%edx
80104aae:	77 20                	ja     80104ad0 <syscall+0x40>
80104ab0:	8b 14 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%edx
80104ab7:	85 d2                	test   %edx,%edx
80104ab9:	74 15                	je     80104ad0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104abb:	ff d2                	call   *%edx
80104abd:	89 c2                	mov    %eax,%edx
80104abf:	8b 43 18             	mov    0x18(%ebx),%eax
80104ac2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac8:	c9                   	leave  
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ad0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ad1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ad4:	50                   	push   %eax
80104ad5:	ff 73 10             	pushl  0x10(%ebx)
80104ad8:	68 dd 77 10 80       	push   $0x801077dd
80104add:	e8 ce bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ae2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af2:	c9                   	leave  
80104af3:	c3                   	ret    
80104af4:	66 90                	xchg   %ax,%ax
80104af6:	66 90                	xchg   %ax,%ax
80104af8:	66 90                	xchg   %ax,%ax
80104afa:	66 90                	xchg   %ax,%ax
80104afc:	66 90                	xchg   %ax,%ax
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b08:	53                   	push   %ebx
80104b09:	83 ec 34             	sub    $0x34,%esp
80104b0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b12:	57                   	push   %edi
80104b13:	50                   	push   %eax
{
80104b14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b1a:	e8 31 d5 ff ff       	call   80102050 <nameiparent>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	0f 84 46 01 00 00    	je     80104c70 <create+0x170>
    return 0;
  ilock(dp);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	89 c3                	mov    %eax,%ebx
80104b2f:	50                   	push   %eax
80104b30:	e8 2b cc ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b35:	83 c4 0c             	add    $0xc,%esp
80104b38:	6a 00                	push   $0x0
80104b3a:	57                   	push   %edi
80104b3b:	53                   	push   %ebx
80104b3c:	e8 6f d1 ff ff       	call   80101cb0 <dirlookup>
80104b41:	83 c4 10             	add    $0x10,%esp
80104b44:	89 c6                	mov    %eax,%esi
80104b46:	85 c0                	test   %eax,%eax
80104b48:	74 56                	je     80104ba0 <create+0xa0>
    iunlockput(dp);
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	53                   	push   %ebx
80104b4e:	e8 ad ce ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104b53:	89 34 24             	mov    %esi,(%esp)
80104b56:	e8 05 cc ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b63:	75 1b                	jne    80104b80 <create+0x80>
80104b65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b6a:	75 14                	jne    80104b80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b6f:	89 f0                	mov    %esi,%eax
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	56                   	push   %esi
    return 0;
80104b84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b86:	e8 75 ce ff ff       	call   80101a00 <iunlockput>
    return 0;
80104b8b:	83 c4 10             	add    $0x10,%esp
}
80104b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b91:	89 f0                	mov    %esi,%eax
80104b93:	5b                   	pop    %ebx
80104b94:	5e                   	pop    %esi
80104b95:	5f                   	pop    %edi
80104b96:	5d                   	pop    %ebp
80104b97:	c3                   	ret    
80104b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ba0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ba4:	83 ec 08             	sub    $0x8,%esp
80104ba7:	50                   	push   %eax
80104ba8:	ff 33                	pushl  (%ebx)
80104baa:	e8 31 ca ff ff       	call   801015e0 <ialloc>
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	89 c6                	mov    %eax,%esi
80104bb4:	85 c0                	test   %eax,%eax
80104bb6:	0f 84 cd 00 00 00    	je     80104c89 <create+0x189>
  ilock(ip);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	50                   	push   %eax
80104bc0:	e8 9b cb ff ff       	call   80101760 <ilock>
  ip->major = major;
80104bc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bde:	89 34 24             	mov    %esi,(%esp)
80104be1:	e8 ba ca ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bee:	74 30                	je     80104c20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bf0:	83 ec 04             	sub    $0x4,%esp
80104bf3:	ff 76 04             	pushl  0x4(%esi)
80104bf6:	57                   	push   %edi
80104bf7:	53                   	push   %ebx
80104bf8:	e8 73 d3 ff ff       	call   80101f70 <dirlink>
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 78                	js     80104c7c <create+0x17c>
  iunlockput(dp);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	53                   	push   %ebx
80104c08:	e8 f3 cd ff ff       	call   80101a00 <iunlockput>
  return ip;
80104c0d:	83 c4 10             	add    $0x10,%esp
}
80104c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c13:	89 f0                	mov    %esi,%eax
80104c15:	5b                   	pop    %ebx
80104c16:	5e                   	pop    %esi
80104c17:	5f                   	pop    %edi
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c28:	53                   	push   %ebx
80104c29:	e8 72 ca ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c2e:	83 c4 0c             	add    $0xc,%esp
80104c31:	ff 76 04             	pushl  0x4(%esi)
80104c34:	68 74 78 10 80       	push   $0x80107874
80104c39:	56                   	push   %esi
80104c3a:	e8 31 d3 ff ff       	call   80101f70 <dirlink>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	78 18                	js     80104c5e <create+0x15e>
80104c46:	83 ec 04             	sub    $0x4,%esp
80104c49:	ff 73 04             	pushl  0x4(%ebx)
80104c4c:	68 73 78 10 80       	push   $0x80107873
80104c51:	56                   	push   %esi
80104c52:	e8 19 d3 ff ff       	call   80101f70 <dirlink>
80104c57:	83 c4 10             	add    $0x10,%esp
80104c5a:	85 c0                	test   %eax,%eax
80104c5c:	79 92                	jns    80104bf0 <create+0xf0>
      panic("create dots");
80104c5e:	83 ec 0c             	sub    $0xc,%esp
80104c61:	68 67 78 10 80       	push   $0x80107867
80104c66:	e8 25 b7 ff ff       	call   80100390 <panic>
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
}
80104c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c73:	31 f6                	xor    %esi,%esi
}
80104c75:	5b                   	pop    %ebx
80104c76:	89 f0                	mov    %esi,%eax
80104c78:	5e                   	pop    %esi
80104c79:	5f                   	pop    %edi
80104c7a:	5d                   	pop    %ebp
80104c7b:	c3                   	ret    
    panic("create: dirlink");
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	68 76 78 10 80       	push   $0x80107876
80104c84:	e8 07 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c89:	83 ec 0c             	sub    $0xc,%esp
80104c8c:	68 58 78 10 80       	push   $0x80107858
80104c91:	e8 fa b6 ff ff       	call   80100390 <panic>
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ca0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	89 d6                	mov    %edx,%esi
80104ca6:	53                   	push   %ebx
80104ca7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104ca9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104caf:	50                   	push   %eax
80104cb0:	6a 00                	push   $0x0
80104cb2:	e8 e9 fc ff ff       	call   801049a0 <argint>
80104cb7:	83 c4 10             	add    $0x10,%esp
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	78 2a                	js     80104ce8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cc2:	77 24                	ja     80104ce8 <argfd.constprop.0+0x48>
80104cc4:	e8 e7 ec ff ff       	call   801039b0 <myproc>
80104cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	74 14                	je     80104ce8 <argfd.constprop.0+0x48>
  if(pfd)
80104cd4:	85 db                	test   %ebx,%ebx
80104cd6:	74 02                	je     80104cda <argfd.constprop.0+0x3a>
    *pfd = fd;
80104cd8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104cda:	89 06                	mov    %eax,(%esi)
  return 0;
80104cdc:	31 c0                	xor    %eax,%eax
}
80104cde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5d                   	pop    %ebp
80104ce4:	c3                   	ret    
80104ce5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ced:	eb ef                	jmp    80104cde <argfd.constprop.0+0x3e>
80104cef:	90                   	nop

80104cf0 <sys_dup>:
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104cf5:	31 c0                	xor    %eax,%eax
{
80104cf7:	89 e5                	mov    %esp,%ebp
80104cf9:	56                   	push   %esi
80104cfa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104cfb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104cfe:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d01:	e8 9a ff ff ff       	call   80104ca0 <argfd.constprop.0>
80104d06:	85 c0                	test   %eax,%eax
80104d08:	78 1e                	js     80104d28 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104d0a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d0d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d0f:	e8 9c ec ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104d18:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d1c:	85 d2                	test   %edx,%edx
80104d1e:	74 20                	je     80104d40 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104d20:	83 c3 01             	add    $0x1,%ebx
80104d23:	83 fb 10             	cmp    $0x10,%ebx
80104d26:	75 f0                	jne    80104d18 <sys_dup+0x28>
}
80104d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d30:	89 d8                	mov    %ebx,%eax
80104d32:	5b                   	pop    %ebx
80104d33:	5e                   	pop    %esi
80104d34:	5d                   	pop    %ebp
80104d35:	c3                   	ret    
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d40:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	ff 75 f4             	pushl  -0xc(%ebp)
80104d4a:	e8 21 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104d4f:	83 c4 10             	add    $0x10,%esp
}
80104d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d55:	89 d8                	mov    %ebx,%eax
80104d57:	5b                   	pop    %ebx
80104d58:	5e                   	pop    %esi
80104d59:	5d                   	pop    %ebp
80104d5a:	c3                   	ret    
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <sys_read>:
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d65:	31 c0                	xor    %eax,%eax
{
80104d67:	89 e5                	mov    %esp,%ebp
80104d69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d6c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d6f:	e8 2c ff ff ff       	call   80104ca0 <argfd.constprop.0>
80104d74:	85 c0                	test   %eax,%eax
80104d76:	78 48                	js     80104dc0 <sys_read+0x60>
80104d78:	83 ec 08             	sub    $0x8,%esp
80104d7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d7e:	50                   	push   %eax
80104d7f:	6a 02                	push   $0x2
80104d81:	e8 1a fc ff ff       	call   801049a0 <argint>
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	85 c0                	test   %eax,%eax
80104d8b:	78 33                	js     80104dc0 <sys_read+0x60>
80104d8d:	83 ec 04             	sub    $0x4,%esp
80104d90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d93:	ff 75 f0             	pushl  -0x10(%ebp)
80104d96:	50                   	push   %eax
80104d97:	6a 01                	push   $0x1
80104d99:	e8 52 fc ff ff       	call   801049f0 <argptr>
80104d9e:	83 c4 10             	add    $0x10,%esp
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 1b                	js     80104dc0 <sys_read+0x60>
  return fileread(f, p, n);
80104da5:	83 ec 04             	sub    $0x4,%esp
80104da8:	ff 75 f0             	pushl  -0x10(%ebp)
80104dab:	ff 75 f4             	pushl  -0xc(%ebp)
80104dae:	ff 75 ec             	pushl  -0x14(%ebp)
80104db1:	e8 3a c2 ff ff       	call   80100ff0 <fileread>
80104db6:	83 c4 10             	add    $0x10,%esp
}
80104db9:	c9                   	leave  
80104dba:	c3                   	ret    
80104dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dbf:	90                   	nop
80104dc0:	c9                   	leave  
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc6:	c3                   	ret    
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <sys_write>:
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd5:	31 c0                	xor    %eax,%eax
{
80104dd7:	89 e5                	mov    %esp,%ebp
80104dd9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ddc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ddf:	e8 bc fe ff ff       	call   80104ca0 <argfd.constprop.0>
80104de4:	85 c0                	test   %eax,%eax
80104de6:	78 48                	js     80104e30 <sys_write+0x60>
80104de8:	83 ec 08             	sub    $0x8,%esp
80104deb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dee:	50                   	push   %eax
80104def:	6a 02                	push   $0x2
80104df1:	e8 aa fb ff ff       	call   801049a0 <argint>
80104df6:	83 c4 10             	add    $0x10,%esp
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	78 33                	js     80104e30 <sys_write+0x60>
80104dfd:	83 ec 04             	sub    $0x4,%esp
80104e00:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e03:	ff 75 f0             	pushl  -0x10(%ebp)
80104e06:	50                   	push   %eax
80104e07:	6a 01                	push   $0x1
80104e09:	e8 e2 fb ff ff       	call   801049f0 <argptr>
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	85 c0                	test   %eax,%eax
80104e13:	78 1b                	js     80104e30 <sys_write+0x60>
  return filewrite(f, p, n);
80104e15:	83 ec 04             	sub    $0x4,%esp
80104e18:	ff 75 f0             	pushl  -0x10(%ebp)
80104e1b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e21:	e8 6a c2 ff ff       	call   80101090 <filewrite>
80104e26:	83 c4 10             	add    $0x10,%esp
}
80104e29:	c9                   	leave  
80104e2a:	c3                   	ret    
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
80104e30:	c9                   	leave  
    return -1;
80104e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e36:	c3                   	ret    
80104e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <sys_close>:
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e50:	e8 4b fe ff ff       	call   80104ca0 <argfd.constprop.0>
80104e55:	85 c0                	test   %eax,%eax
80104e57:	78 27                	js     80104e80 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e59:	e8 52 eb ff ff       	call   801039b0 <myproc>
80104e5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e61:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e64:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e6b:	00 
  fileclose(f);
80104e6c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e6f:	e8 4c c0 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104e74:	83 c4 10             	add    $0x10,%esp
80104e77:	31 c0                	xor    %eax,%eax
}
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
80104e80:	c9                   	leave  
    return -1;
80104e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e86:	c3                   	ret    
80104e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <sys_fstat>:
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e95:	31 c0                	xor    %eax,%eax
{
80104e97:	89 e5                	mov    %esp,%ebp
80104e99:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e9c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e9f:	e8 fc fd ff ff       	call   80104ca0 <argfd.constprop.0>
80104ea4:	85 c0                	test   %eax,%eax
80104ea6:	78 30                	js     80104ed8 <sys_fstat+0x48>
80104ea8:	83 ec 04             	sub    $0x4,%esp
80104eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eae:	6a 14                	push   $0x14
80104eb0:	50                   	push   %eax
80104eb1:	6a 01                	push   $0x1
80104eb3:	e8 38 fb ff ff       	call   801049f0 <argptr>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	78 19                	js     80104ed8 <sys_fstat+0x48>
  return filestat(f, st);
80104ebf:	83 ec 08             	sub    $0x8,%esp
80104ec2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ec5:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec8:	e8 d3 c0 ff ff       	call   80100fa0 <filestat>
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	c9                   	leave  
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed8:	c9                   	leave  
    return -1;
80104ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ede:	c3                   	ret    
80104edf:	90                   	nop

80104ee0 <sys_link>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	57                   	push   %edi
80104ee8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ee9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104eec:	53                   	push   %ebx
80104eed:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ef0:	50                   	push   %eax
80104ef1:	6a 00                	push   $0x0
80104ef3:	e8 58 fb ff ff       	call   80104a50 <argstr>
80104ef8:	83 c4 10             	add    $0x10,%esp
80104efb:	85 c0                	test   %eax,%eax
80104efd:	0f 88 ff 00 00 00    	js     80105002 <sys_link+0x122>
80104f03:	83 ec 08             	sub    $0x8,%esp
80104f06:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f09:	50                   	push   %eax
80104f0a:	6a 01                	push   $0x1
80104f0c:	e8 3f fb ff ff       	call   80104a50 <argstr>
80104f11:	83 c4 10             	add    $0x10,%esp
80104f14:	85 c0                	test   %eax,%eax
80104f16:	0f 88 e6 00 00 00    	js     80105002 <sys_link+0x122>
  begin_op();
80104f1c:	e8 5f de ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
80104f21:	83 ec 0c             	sub    $0xc,%esp
80104f24:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f27:	e8 04 d1 ff ff       	call   80102030 <namei>
80104f2c:	83 c4 10             	add    $0x10,%esp
80104f2f:	89 c3                	mov    %eax,%ebx
80104f31:	85 c0                	test   %eax,%eax
80104f33:	0f 84 e8 00 00 00    	je     80105021 <sys_link+0x141>
  ilock(ip);
80104f39:	83 ec 0c             	sub    $0xc,%esp
80104f3c:	50                   	push   %eax
80104f3d:	e8 1e c8 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f4a:	0f 84 b9 00 00 00    	je     80105009 <sys_link+0x129>
  iupdate(ip);
80104f50:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f53:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f58:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f5b:	53                   	push   %ebx
80104f5c:	e8 3f c7 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80104f61:	89 1c 24             	mov    %ebx,(%esp)
80104f64:	e8 d7 c8 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f69:	58                   	pop    %eax
80104f6a:	5a                   	pop    %edx
80104f6b:	57                   	push   %edi
80104f6c:	ff 75 d0             	pushl  -0x30(%ebp)
80104f6f:	e8 dc d0 ff ff       	call   80102050 <nameiparent>
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	89 c6                	mov    %eax,%esi
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	74 5f                	je     80104fdc <sys_link+0xfc>
  ilock(dp);
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	50                   	push   %eax
80104f81:	e8 da c7 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f86:	8b 03                	mov    (%ebx),%eax
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	39 06                	cmp    %eax,(%esi)
80104f8d:	75 41                	jne    80104fd0 <sys_link+0xf0>
80104f8f:	83 ec 04             	sub    $0x4,%esp
80104f92:	ff 73 04             	pushl  0x4(%ebx)
80104f95:	57                   	push   %edi
80104f96:	56                   	push   %esi
80104f97:	e8 d4 cf ff ff       	call   80101f70 <dirlink>
80104f9c:	83 c4 10             	add    $0x10,%esp
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	78 2d                	js     80104fd0 <sys_link+0xf0>
  iunlockput(dp);
80104fa3:	83 ec 0c             	sub    $0xc,%esp
80104fa6:	56                   	push   %esi
80104fa7:	e8 54 ca ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80104fac:	89 1c 24             	mov    %ebx,(%esp)
80104faf:	e8 dc c8 ff ff       	call   80101890 <iput>
  end_op();
80104fb4:	e8 37 de ff ff       	call   80102df0 <end_op>
  return 0;
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	31 c0                	xor    %eax,%eax
}
80104fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fc1:	5b                   	pop    %ebx
80104fc2:	5e                   	pop    %esi
80104fc3:	5f                   	pop    %edi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fd0:	83 ec 0c             	sub    $0xc,%esp
80104fd3:	56                   	push   %esi
80104fd4:	e8 27 ca ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104fd9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fdc:	83 ec 0c             	sub    $0xc,%esp
80104fdf:	53                   	push   %ebx
80104fe0:	e8 7b c7 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80104fe5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fea:	89 1c 24             	mov    %ebx,(%esp)
80104fed:	e8 ae c6 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80104ff2:	89 1c 24             	mov    %ebx,(%esp)
80104ff5:	e8 06 ca ff ff       	call   80101a00 <iunlockput>
  end_op();
80104ffa:	e8 f1 dd ff ff       	call   80102df0 <end_op>
  return -1;
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105007:	eb b5                	jmp    80104fbe <sys_link+0xde>
    iunlockput(ip);
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	53                   	push   %ebx
8010500d:	e8 ee c9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105012:	e8 d9 dd ff ff       	call   80102df0 <end_op>
    return -1;
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501f:	eb 9d                	jmp    80104fbe <sys_link+0xde>
    end_op();
80105021:	e8 ca dd ff ff       	call   80102df0 <end_op>
    return -1;
80105026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502b:	eb 91                	jmp    80104fbe <sys_link+0xde>
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <sys_unlink>:
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	57                   	push   %edi
80105038:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105039:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010503c:	53                   	push   %ebx
8010503d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105040:	50                   	push   %eax
80105041:	6a 00                	push   $0x0
80105043:	e8 08 fa ff ff       	call   80104a50 <argstr>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	0f 88 7d 01 00 00    	js     801051d0 <sys_unlink+0x1a0>
  begin_op();
80105053:	e8 28 dd ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105058:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010505b:	83 ec 08             	sub    $0x8,%esp
8010505e:	53                   	push   %ebx
8010505f:	ff 75 c0             	pushl  -0x40(%ebp)
80105062:	e8 e9 cf ff ff       	call   80102050 <nameiparent>
80105067:	83 c4 10             	add    $0x10,%esp
8010506a:	89 c6                	mov    %eax,%esi
8010506c:	85 c0                	test   %eax,%eax
8010506e:	0f 84 66 01 00 00    	je     801051da <sys_unlink+0x1aa>
  ilock(dp);
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	50                   	push   %eax
80105078:	e8 e3 c6 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010507d:	58                   	pop    %eax
8010507e:	5a                   	pop    %edx
8010507f:	68 74 78 10 80       	push   $0x80107874
80105084:	53                   	push   %ebx
80105085:	e8 06 cc ff ff       	call   80101c90 <namecmp>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	0f 84 03 01 00 00    	je     80105198 <sys_unlink+0x168>
80105095:	83 ec 08             	sub    $0x8,%esp
80105098:	68 73 78 10 80       	push   $0x80107873
8010509d:	53                   	push   %ebx
8010509e:	e8 ed cb ff ff       	call   80101c90 <namecmp>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	0f 84 ea 00 00 00    	je     80105198 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050ae:	83 ec 04             	sub    $0x4,%esp
801050b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050b4:	50                   	push   %eax
801050b5:	53                   	push   %ebx
801050b6:	56                   	push   %esi
801050b7:	e8 f4 cb ff ff       	call   80101cb0 <dirlookup>
801050bc:	83 c4 10             	add    $0x10,%esp
801050bf:	89 c3                	mov    %eax,%ebx
801050c1:	85 c0                	test   %eax,%eax
801050c3:	0f 84 cf 00 00 00    	je     80105198 <sys_unlink+0x168>
  ilock(ip);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	50                   	push   %eax
801050cd:	e8 8e c6 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050da:	0f 8e 23 01 00 00    	jle    80105203 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050e8:	74 66                	je     80105150 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	6a 10                	push   $0x10
801050ef:	6a 00                	push   $0x0
801050f1:	57                   	push   %edi
801050f2:	e8 c9 f5 ff ff       	call   801046c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050f7:	6a 10                	push   $0x10
801050f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801050fc:	57                   	push   %edi
801050fd:	56                   	push   %esi
801050fe:	e8 5d ca ff ff       	call   80101b60 <writei>
80105103:	83 c4 20             	add    $0x20,%esp
80105106:	83 f8 10             	cmp    $0x10,%eax
80105109:	0f 85 e7 00 00 00    	jne    801051f6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010510f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105114:	0f 84 96 00 00 00    	je     801051b0 <sys_unlink+0x180>
  iunlockput(dp);
8010511a:	83 ec 0c             	sub    $0xc,%esp
8010511d:	56                   	push   %esi
8010511e:	e8 dd c8 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105123:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105128:	89 1c 24             	mov    %ebx,(%esp)
8010512b:	e8 70 c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105130:	89 1c 24             	mov    %ebx,(%esp)
80105133:	e8 c8 c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105138:	e8 b3 dc ff ff       	call   80102df0 <end_op>
  return 0;
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	31 c0                	xor    %eax,%eax
}
80105142:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105145:	5b                   	pop    %ebx
80105146:	5e                   	pop    %esi
80105147:	5f                   	pop    %edi
80105148:	5d                   	pop    %ebp
80105149:	c3                   	ret    
8010514a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105150:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105154:	76 94                	jbe    801050ea <sys_unlink+0xba>
80105156:	ba 20 00 00 00       	mov    $0x20,%edx
8010515b:	eb 0b                	jmp    80105168 <sys_unlink+0x138>
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	83 c2 10             	add    $0x10,%edx
80105163:	39 53 58             	cmp    %edx,0x58(%ebx)
80105166:	76 82                	jbe    801050ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105168:	6a 10                	push   $0x10
8010516a:	52                   	push   %edx
8010516b:	57                   	push   %edi
8010516c:	53                   	push   %ebx
8010516d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105170:	e8 eb c8 ff ff       	call   80101a60 <readi>
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010517b:	83 f8 10             	cmp    $0x10,%eax
8010517e:	75 69                	jne    801051e9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105180:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105185:	74 d9                	je     80105160 <sys_unlink+0x130>
    iunlockput(ip);
80105187:	83 ec 0c             	sub    $0xc,%esp
8010518a:	53                   	push   %ebx
8010518b:	e8 70 c8 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105197:	90                   	nop
  iunlockput(dp);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	56                   	push   %esi
8010519c:	e8 5f c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
801051a1:	e8 4a dc ff ff       	call   80102df0 <end_op>
  return -1;
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ae:	eb 92                	jmp    80105142 <sys_unlink+0x112>
    iupdate(dp);
801051b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051b3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051b8:	56                   	push   %esi
801051b9:	e8 e2 c4 ff ff       	call   801016a0 <iupdate>
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	e9 54 ff ff ff       	jmp    8010511a <sys_unlink+0xea>
801051c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	e9 68 ff ff ff       	jmp    80105142 <sys_unlink+0x112>
    end_op();
801051da:	e8 11 dc ff ff       	call   80102df0 <end_op>
    return -1;
801051df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e4:	e9 59 ff ff ff       	jmp    80105142 <sys_unlink+0x112>
      panic("isdirempty: readi");
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	68 98 78 10 80       	push   $0x80107898
801051f1:	e8 9a b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801051f6:	83 ec 0c             	sub    $0xc,%esp
801051f9:	68 aa 78 10 80       	push   $0x801078aa
801051fe:	e8 8d b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105203:	83 ec 0c             	sub    $0xc,%esp
80105206:	68 86 78 10 80       	push   $0x80107886
8010520b:	e8 80 b1 ff ff       	call   80100390 <panic>

80105210 <sys_open>:

int
sys_open(void)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	57                   	push   %edi
80105218:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105219:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010521c:	53                   	push   %ebx
8010521d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105220:	50                   	push   %eax
80105221:	6a 00                	push   $0x0
80105223:	e8 28 f8 ff ff       	call   80104a50 <argstr>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	0f 88 8a 00 00 00    	js     801052bd <sys_open+0xad>
80105233:	83 ec 08             	sub    $0x8,%esp
80105236:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105239:	50                   	push   %eax
8010523a:	6a 01                	push   $0x1
8010523c:	e8 5f f7 ff ff       	call   801049a0 <argint>
80105241:	83 c4 10             	add    $0x10,%esp
80105244:	85 c0                	test   %eax,%eax
80105246:	78 75                	js     801052bd <sys_open+0xad>
    return -1;

  begin_op();
80105248:	e8 33 db ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
8010524d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105251:	75 75                	jne    801052c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105253:	83 ec 0c             	sub    $0xc,%esp
80105256:	ff 75 e0             	pushl  -0x20(%ebp)
80105259:	e8 d2 cd ff ff       	call   80102030 <namei>
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	89 c6                	mov    %eax,%esi
80105263:	85 c0                	test   %eax,%eax
80105265:	74 7e                	je     801052e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105267:	83 ec 0c             	sub    $0xc,%esp
8010526a:	50                   	push   %eax
8010526b:	e8 f0 c4 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105278:	0f 84 c2 00 00 00    	je     80105340 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010527e:	e8 7d bb ff ff       	call   80100e00 <filealloc>
80105283:	89 c7                	mov    %eax,%edi
80105285:	85 c0                	test   %eax,%eax
80105287:	74 23                	je     801052ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105289:	e8 22 e7 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010528e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	74 60                	je     801052f8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105298:	83 c3 01             	add    $0x1,%ebx
8010529b:	83 fb 10             	cmp    $0x10,%ebx
8010529e:	75 f0                	jne    80105290 <sys_open+0x80>
    if(f)
      fileclose(f);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	57                   	push   %edi
801052a4:	e8 17 bc ff ff       	call   80100ec0 <fileclose>
801052a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	56                   	push   %esi
801052b0:	e8 4b c7 ff ff       	call   80101a00 <iunlockput>
    end_op();
801052b5:	e8 36 db ff ff       	call   80102df0 <end_op>
    return -1;
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052c2:	eb 6d                	jmp    80105331 <sys_open+0x121>
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052c8:	83 ec 0c             	sub    $0xc,%esp
801052cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052ce:	31 c9                	xor    %ecx,%ecx
801052d0:	ba 02 00 00 00       	mov    $0x2,%edx
801052d5:	6a 00                	push   $0x0
801052d7:	e8 24 f8 ff ff       	call   80104b00 <create>
    if(ip == 0){
801052dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052e1:	85 c0                	test   %eax,%eax
801052e3:	75 99                	jne    8010527e <sys_open+0x6e>
      end_op();
801052e5:	e8 06 db ff ff       	call   80102df0 <end_op>
      return -1;
801052ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052ef:	eb 40                	jmp    80105331 <sys_open+0x121>
801052f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052ff:	56                   	push   %esi
80105300:	e8 3b c5 ff ff       	call   80101840 <iunlock>
  end_op();
80105305:	e8 e6 da ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
8010530a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105313:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105316:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105319:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010531b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105322:	f7 d0                	not    %eax
80105324:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105327:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010532a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010532d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105331:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105334:	89 d8                	mov    %ebx,%eax
80105336:	5b                   	pop    %ebx
80105337:	5e                   	pop    %esi
80105338:	5f                   	pop    %edi
80105339:	5d                   	pop    %ebp
8010533a:	c3                   	ret    
8010533b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010533f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105340:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105343:	85 c9                	test   %ecx,%ecx
80105345:	0f 84 33 ff ff ff    	je     8010527e <sys_open+0x6e>
8010534b:	e9 5c ff ff ff       	jmp    801052ac <sys_open+0x9c>

80105350 <sys_mkdir>:

int
sys_mkdir(void)
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010535a:	e8 21 da ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010535f:	83 ec 08             	sub    $0x8,%esp
80105362:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105365:	50                   	push   %eax
80105366:	6a 00                	push   $0x0
80105368:	e8 e3 f6 ff ff       	call   80104a50 <argstr>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	78 34                	js     801053a8 <sys_mkdir+0x58>
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537a:	31 c9                	xor    %ecx,%ecx
8010537c:	ba 01 00 00 00       	mov    $0x1,%edx
80105381:	6a 00                	push   $0x0
80105383:	e8 78 f7 ff ff       	call   80104b00 <create>
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	85 c0                	test   %eax,%eax
8010538d:	74 19                	je     801053a8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538f:	83 ec 0c             	sub    $0xc,%esp
80105392:	50                   	push   %eax
80105393:	e8 68 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105398:	e8 53 da ff ff       	call   80102df0 <end_op>
  return 0;
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	31 c0                	xor    %eax,%eax
}
801053a2:	c9                   	leave  
801053a3:	c3                   	ret    
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053a8:	e8 43 da ff ff       	call   80102df0 <end_op>
    return -1;
801053ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop

801053c0 <sys_mknod>:

int
sys_mknod(void)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053ca:	e8 b1 d9 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053cf:	83 ec 08             	sub    $0x8,%esp
801053d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053d5:	50                   	push   %eax
801053d6:	6a 00                	push   $0x0
801053d8:	e8 73 f6 ff ff       	call   80104a50 <argstr>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	85 c0                	test   %eax,%eax
801053e2:	78 64                	js     80105448 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ea:	50                   	push   %eax
801053eb:	6a 01                	push   $0x1
801053ed:	e8 ae f5 ff ff       	call   801049a0 <argint>
  if((argstr(0, &path)) < 0 ||
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	85 c0                	test   %eax,%eax
801053f7:	78 4f                	js     80105448 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801053f9:	83 ec 08             	sub    $0x8,%esp
801053fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ff:	50                   	push   %eax
80105400:	6a 02                	push   $0x2
80105402:	e8 99 f5 ff ff       	call   801049a0 <argint>
     argint(1, &major) < 0 ||
80105407:	83 c4 10             	add    $0x10,%esp
8010540a:	85 c0                	test   %eax,%eax
8010540c:	78 3a                	js     80105448 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010540e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105412:	83 ec 0c             	sub    $0xc,%esp
80105415:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105419:	ba 03 00 00 00       	mov    $0x3,%edx
8010541e:	50                   	push   %eax
8010541f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105422:	e8 d9 f6 ff ff       	call   80104b00 <create>
     argint(2, &minor) < 0 ||
80105427:	83 c4 10             	add    $0x10,%esp
8010542a:	85 c0                	test   %eax,%eax
8010542c:	74 1a                	je     80105448 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010542e:	83 ec 0c             	sub    $0xc,%esp
80105431:	50                   	push   %eax
80105432:	e8 c9 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105437:	e8 b4 d9 ff ff       	call   80102df0 <end_op>
  return 0;
8010543c:	83 c4 10             	add    $0x10,%esp
8010543f:	31 c0                	xor    %eax,%eax
}
80105441:	c9                   	leave  
80105442:	c3                   	ret    
80105443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105447:	90                   	nop
    end_op();
80105448:	e8 a3 d9 ff ff       	call   80102df0 <end_op>
    return -1;
8010544d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105452:	c9                   	leave  
80105453:	c3                   	ret    
80105454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop

80105460 <sys_chdir>:

int
sys_chdir(void)
{
80105460:	f3 0f 1e fb          	endbr32 
80105464:	55                   	push   %ebp
80105465:	89 e5                	mov    %esp,%ebp
80105467:	56                   	push   %esi
80105468:	53                   	push   %ebx
80105469:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010546c:	e8 3f e5 ff ff       	call   801039b0 <myproc>
80105471:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105473:	e8 08 d9 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105478:	83 ec 08             	sub    $0x8,%esp
8010547b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 ca f5 ff ff       	call   80104a50 <argstr>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 73                	js     80105500 <sys_chdir+0xa0>
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	ff 75 f4             	pushl  -0xc(%ebp)
80105493:	e8 98 cb ff ff       	call   80102030 <namei>
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	89 c3                	mov    %eax,%ebx
8010549d:	85 c0                	test   %eax,%eax
8010549f:	74 5f                	je     80105500 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	50                   	push   %eax
801054a5:	e8 b6 c2 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054b2:	75 2c                	jne    801054e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054b4:	83 ec 0c             	sub    $0xc,%esp
801054b7:	53                   	push   %ebx
801054b8:	e8 83 c3 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801054bd:	58                   	pop    %eax
801054be:	ff 76 68             	pushl  0x68(%esi)
801054c1:	e8 ca c3 ff ff       	call   80101890 <iput>
  end_op();
801054c6:	e8 25 d9 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
801054cb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	31 c0                	xor    %eax,%eax
}
801054d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d6:	5b                   	pop    %ebx
801054d7:	5e                   	pop    %esi
801054d8:	5d                   	pop    %ebp
801054d9:	c3                   	ret    
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 17 c5 ff ff       	call   80101a00 <iunlockput>
    end_op();
801054e9:	e8 02 d9 ff ff       	call   80102df0 <end_op>
    return -1;
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f6:	eb db                	jmp    801054d3 <sys_chdir+0x73>
801054f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
    end_op();
80105500:	e8 eb d8 ff ff       	call   80102df0 <end_op>
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550a:	eb c7                	jmp    801054d3 <sys_chdir+0x73>
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_exec>:

int
sys_exec(void)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105519:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010551f:	53                   	push   %ebx
80105520:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105526:	50                   	push   %eax
80105527:	6a 00                	push   $0x0
80105529:	e8 22 f5 ff ff       	call   80104a50 <argstr>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	0f 88 8b 00 00 00    	js     801055c4 <sys_exec+0xb4>
80105539:	83 ec 08             	sub    $0x8,%esp
8010553c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105542:	50                   	push   %eax
80105543:	6a 01                	push   $0x1
80105545:	e8 56 f4 ff ff       	call   801049a0 <argint>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	78 73                	js     801055c4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105551:	83 ec 04             	sub    $0x4,%esp
80105554:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010555a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010555c:	68 80 00 00 00       	push   $0x80
80105561:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105567:	6a 00                	push   $0x0
80105569:	50                   	push   %eax
8010556a:	e8 51 f1 ff ff       	call   801046c0 <memset>
8010556f:	83 c4 10             	add    $0x10,%esp
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105578:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010557e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105585:	83 ec 08             	sub    $0x8,%esp
80105588:	57                   	push   %edi
80105589:	01 f0                	add    %esi,%eax
8010558b:	50                   	push   %eax
8010558c:	e8 6f f3 ff ff       	call   80104900 <fetchint>
80105591:	83 c4 10             	add    $0x10,%esp
80105594:	85 c0                	test   %eax,%eax
80105596:	78 2c                	js     801055c4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105598:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010559e:	85 c0                	test   %eax,%eax
801055a0:	74 36                	je     801055d8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055a2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055ae:	52                   	push   %edx
801055af:	50                   	push   %eax
801055b0:	e8 8b f3 ff ff       	call   80104940 <fetchstr>
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	85 c0                	test   %eax,%eax
801055ba:	78 08                	js     801055c4 <sys_exec+0xb4>
  for(i=0;; i++){
801055bc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055bf:	83 fb 20             	cmp    $0x20,%ebx
801055c2:	75 b4                	jne    80105578 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801055c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055cc:	5b                   	pop    %ebx
801055cd:	5e                   	pop    %esi
801055ce:	5f                   	pop    %edi
801055cf:	5d                   	pop    %ebp
801055d0:	c3                   	ret    
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801055e1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055e8:	00 00 00 00 
  return exec(path, argv);
801055ec:	50                   	push   %eax
801055ed:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055f3:	e8 88 b4 ff ff       	call   80100a80 <exec>
801055f8:	83 c4 10             	add    $0x10,%esp
}
801055fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fe:	5b                   	pop    %ebx
801055ff:	5e                   	pop    %esi
80105600:	5f                   	pop    %edi
80105601:	5d                   	pop    %ebp
80105602:	c3                   	ret    
80105603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105610 <sys_pipe>:

int
sys_pipe(void)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	57                   	push   %edi
80105618:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105619:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010561c:	53                   	push   %ebx
8010561d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105620:	6a 08                	push   $0x8
80105622:	50                   	push   %eax
80105623:	6a 00                	push   $0x0
80105625:	e8 c6 f3 ff ff       	call   801049f0 <argptr>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	78 4e                	js     8010567f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105631:	83 ec 08             	sub    $0x8,%esp
80105634:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105637:	50                   	push   %eax
80105638:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010563b:	50                   	push   %eax
8010563c:	e8 ff dd ff ff       	call   80103440 <pipealloc>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	78 37                	js     8010567f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105648:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010564b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010564d:	e8 5e e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105658:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010565c:	85 f6                	test   %esi,%esi
8010565e:	74 30                	je     80105690 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105660:	83 c3 01             	add    $0x1,%ebx
80105663:	83 fb 10             	cmp    $0x10,%ebx
80105666:	75 f0                	jne    80105658 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	ff 75 e0             	pushl  -0x20(%ebp)
8010566e:	e8 4d b8 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105673:	58                   	pop    %eax
80105674:	ff 75 e4             	pushl  -0x1c(%ebp)
80105677:	e8 44 b8 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105684:	eb 5b                	jmp    801056e1 <sys_pipe+0xd1>
80105686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105690:	8d 73 08             	lea    0x8(%ebx),%esi
80105693:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105697:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010569a:	e8 11 e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010569f:	31 d2                	xor    %edx,%edx
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056ac:	85 c9                	test   %ecx,%ecx
801056ae:	74 20                	je     801056d0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801056b0:	83 c2 01             	add    $0x1,%edx
801056b3:	83 fa 10             	cmp    $0x10,%edx
801056b6:	75 f0                	jne    801056a8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801056b8:	e8 f3 e2 ff ff       	call   801039b0 <myproc>
801056bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056c4:	00 
801056c5:	eb a1                	jmp    80105668 <sys_pipe+0x58>
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056df:	31 c0                	xor    %eax,%eax
}
801056e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e4:	5b                   	pop    %ebx
801056e5:	5e                   	pop    %esi
801056e6:	5f                   	pop    %edi
801056e7:	5d                   	pop    %ebp
801056e8:	c3                   	ret    
801056e9:	66 90                	xchg   %ax,%ax
801056eb:	66 90                	xchg   %ax,%ax
801056ed:	66 90                	xchg   %ax,%ax
801056ef:	90                   	nop

801056f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
  return fork();
801056f4:	e9 67 e4 ff ff       	jmp    80103b60 <fork>
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exit>:
}

int
sys_exit(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	83 ec 08             	sub    $0x8,%esp
  exit();
8010570a:	e8 d1 e6 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
8010570f:	31 c0                	xor    %eax,%eax
80105711:	c9                   	leave  
80105712:	c3                   	ret    
80105713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <sys_wait>:

int
sys_wait(void)
{
80105720:	f3 0f 1e fb          	endbr32 
  return wait();
80105724:	e9 07 e9 ff ff       	jmp    80104030 <wait>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_kill>:
}

int
sys_kill(void)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
80105735:	89 e5                	mov    %esp,%ebp
80105737:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010573a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573d:	50                   	push   %eax
8010573e:	6a 00                	push   $0x0
80105740:	e8 5b f2 ff ff       	call   801049a0 <argint>
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	85 c0                	test   %eax,%eax
8010574a:	78 14                	js     80105760 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	ff 75 f4             	pushl  -0xc(%ebp)
80105752:	e8 39 ea ff ff       	call   80104190 <kill>
80105757:	83 c4 10             	add    $0x10,%esp
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105760:	c9                   	leave  
    return -1;
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105766:	c3                   	ret    
80105767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576e:	66 90                	xchg   %ax,%ax

80105770 <sys_getpid>:

int
sys_getpid(void)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010577a:	e8 31 e2 ff ff       	call   801039b0 <myproc>
8010577f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105782:	c9                   	leave  
80105783:	c3                   	ret    
80105784:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105798:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010579b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579e:	50                   	push   %eax
8010579f:	6a 00                	push   $0x0
801057a1:	e8 fa f1 ff ff       	call   801049a0 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 23                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057ad:	e8 fe e1 ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
801057b2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ba:	e8 21 e3 ff ff       	call   80103ae0 <growproc>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 0a                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c6:	89 d8                	mov    %ebx,%eax
801057c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057cb:	c9                   	leave  
801057cc:	c3                   	ret    
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb ef                	jmp    801057c6 <sys_sbrk+0x36>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ee:	50                   	push   %eax
801057ef:	6a 00                	push   $0x0
801057f1:	e8 aa f1 ff ff       	call   801049a0 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	0f 88 86 00 00 00    	js     80105887 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	68 00 f6 14 80       	push   $0x8014f600
80105809:	e8 a2 ed ff ff       	call   801045b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010580e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105811:	8b 1d 40 fe 14 80    	mov    0x8014fe40,%ebx
  while(ticks - ticks0 < n){
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 d2                	test   %edx,%edx
8010581c:	75 23                	jne    80105841 <sys_sleep+0x61>
8010581e:	eb 50                	jmp    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 00 f6 14 80       	push   $0x8014f600
80105828:	68 40 fe 14 80       	push   $0x8014fe40
8010582d:	e8 3e e7 ff ff       	call   80103f70 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 40 fe 14 80       	mov    0x8014fe40,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 6a e1 ff ff       	call   801039b0 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 00 f6 14 80       	push   $0x8014f600
80105855:	e8 16 ee ff ff       	call   80104670 <release>
  }
  release(&tickslock);
  return 0;
}
8010585a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 00 f6 14 80       	push   $0x8014f600
80105878:	e8 f3 ed ff ff       	call   80104670 <release>
  return 0;
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
    return -1;
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb f4                	jmp    80105882 <sys_sleep+0xa2>
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	53                   	push   %ebx
80105898:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010589b:	68 00 f6 14 80       	push   $0x8014f600
801058a0:	e8 0b ed ff ff       	call   801045b0 <acquire>
  xticks = ticks;
801058a5:	8b 1d 40 fe 14 80    	mov    0x8014fe40,%ebx
  release(&tickslock);
801058ab:	c7 04 24 00 f6 14 80 	movl   $0x8014f600,(%esp)
801058b2:	e8 b9 ed ff ff       	call   80104670 <release>
  return xticks;
}
801058b7:	89 d8                	mov    %ebx,%eax
801058b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058bc:	c9                   	leave  
801058bd:	c3                   	ret    

801058be <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058be:	1e                   	push   %ds
  pushl %es
801058bf:	06                   	push   %es
  pushl %fs
801058c0:	0f a0                	push   %fs
  pushl %gs
801058c2:	0f a8                	push   %gs
  pushal
801058c4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058c5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058c9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058cb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058cd:	54                   	push   %esp
  call trap
801058ce:	e8 cd 00 00 00       	call   801059a0 <trap>
  addl $4, %esp
801058d3:	83 c4 04             	add    $0x4,%esp

801058d6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058d6:	61                   	popa   
  popl %gs
801058d7:	0f a9                	pop    %gs
  popl %fs
801058d9:	0f a1                	pop    %fs
  popl %es
801058db:	07                   	pop    %es
  popl %ds
801058dc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058dd:	83 c4 08             	add    $0x8,%esp
  iret
801058e0:	cf                   	iret   
801058e1:	66 90                	xchg   %ax,%ax
801058e3:	66 90                	xchg   %ax,%ax
801058e5:	66 90                	xchg   %ax,%ax
801058e7:	66 90                	xchg   %ax,%ax
801058e9:	66 90                	xchg   %ax,%ax
801058eb:	66 90                	xchg   %ax,%ax
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058f5:	31 c0                	xor    %eax,%eax
{
801058f7:	89 e5                	mov    %esp,%ebp
801058f9:	83 ec 08             	sub    $0x8,%esp
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105900:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105907:	c7 04 c5 42 f6 14 80 	movl   $0x8e000008,-0x7feb09be(,%eax,8)
8010590e:	08 00 00 8e 
80105912:	66 89 14 c5 40 f6 14 	mov    %dx,-0x7feb09c0(,%eax,8)
80105919:	80 
8010591a:	c1 ea 10             	shr    $0x10,%edx
8010591d:	66 89 14 c5 46 f6 14 	mov    %dx,-0x7feb09ba(,%eax,8)
80105924:	80 
  for(i = 0; i < 256; i++)
80105925:	83 c0 01             	add    $0x1,%eax
80105928:	3d 00 01 00 00       	cmp    $0x100,%eax
8010592d:	75 d1                	jne    80105900 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010592f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105932:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105937:	c7 05 42 f8 14 80 08 	movl   $0xef000008,0x8014f842
8010593e:	00 00 ef 
  initlock(&tickslock, "time");
80105941:	68 b9 78 10 80       	push   $0x801078b9
80105946:	68 00 f6 14 80       	push   $0x8014f600
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010594b:	66 a3 40 f8 14 80    	mov    %ax,0x8014f840
80105951:	c1 e8 10             	shr    $0x10,%eax
80105954:	66 a3 46 f8 14 80    	mov    %ax,0x8014f846
  initlock(&tickslock, "time");
8010595a:	e8 d1 ea ff ff       	call   80104430 <initlock>
}
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <idtinit>:

void
idtinit(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
  pd[0] = size-1;
80105975:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010597a:	89 e5                	mov    %esp,%ebp
8010597c:	83 ec 10             	sub    $0x10,%esp
8010597f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105983:	b8 40 f6 14 80       	mov    $0x8014f640,%eax
80105988:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010598c:	c1 e8 10             	shr    $0x10,%eax
8010598f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105993:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105996:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105999:	c9                   	leave  
8010599a:	c3                   	ret    
8010599b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop

801059a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059a0:	f3 0f 1e fb          	endbr32 
801059a4:	55                   	push   %ebp
801059a5:	89 e5                	mov    %esp,%ebp
801059a7:	57                   	push   %edi
801059a8:	56                   	push   %esi
801059a9:	53                   	push   %ebx
801059aa:	83 ec 1c             	sub    $0x1c,%esp
801059ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059b0:	8b 43 30             	mov    0x30(%ebx),%eax
801059b3:	83 f8 40             	cmp    $0x40,%eax
801059b6:	0f 84 bc 01 00 00    	je     80105b78 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059bc:	83 e8 20             	sub    $0x20,%eax
801059bf:	83 f8 1f             	cmp    $0x1f,%eax
801059c2:	77 08                	ja     801059cc <trap+0x2c>
801059c4:	3e ff 24 85 60 79 10 	notrack jmp *-0x7fef86a0(,%eax,4)
801059cb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059cc:	e8 df df ff ff       	call   801039b0 <myproc>
801059d1:	8b 7b 38             	mov    0x38(%ebx),%edi
801059d4:	85 c0                	test   %eax,%eax
801059d6:	0f 84 eb 01 00 00    	je     80105bc7 <trap+0x227>
801059dc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801059e0:	0f 84 e1 01 00 00    	je     80105bc7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059e6:	0f 20 d1             	mov    %cr2,%ecx
801059e9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059ec:	e8 9f df ff ff       	call   80103990 <cpuid>
801059f1:	8b 73 30             	mov    0x30(%ebx),%esi
801059f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059f7:	8b 43 34             	mov    0x34(%ebx),%eax
801059fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801059fd:	e8 ae df ff ff       	call   801039b0 <myproc>
80105a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a05:	e8 a6 df ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a0a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a10:	51                   	push   %ecx
80105a11:	57                   	push   %edi
80105a12:	52                   	push   %edx
80105a13:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a16:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a17:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a1a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1d:	56                   	push   %esi
80105a1e:	ff 70 10             	pushl  0x10(%eax)
80105a21:	68 1c 79 10 80       	push   $0x8010791c
80105a26:	e8 85 ac ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a2b:	83 c4 20             	add    $0x20,%esp
80105a2e:	e8 7d df ff ff       	call   801039b0 <myproc>
80105a33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a3a:	e8 71 df ff ff       	call   801039b0 <myproc>
80105a3f:	85 c0                	test   %eax,%eax
80105a41:	74 1d                	je     80105a60 <trap+0xc0>
80105a43:	e8 68 df ff ff       	call   801039b0 <myproc>
80105a48:	8b 50 24             	mov    0x24(%eax),%edx
80105a4b:	85 d2                	test   %edx,%edx
80105a4d:	74 11                	je     80105a60 <trap+0xc0>
80105a4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a53:	83 e0 03             	and    $0x3,%eax
80105a56:	66 83 f8 03          	cmp    $0x3,%ax
80105a5a:	0f 84 50 01 00 00    	je     80105bb0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a60:	e8 4b df ff ff       	call   801039b0 <myproc>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	74 0f                	je     80105a78 <trap+0xd8>
80105a69:	e8 42 df ff ff       	call   801039b0 <myproc>
80105a6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a72:	0f 84 e8 00 00 00    	je     80105b60 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a78:	e8 33 df ff ff       	call   801039b0 <myproc>
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	74 1d                	je     80105a9e <trap+0xfe>
80105a81:	e8 2a df ff ff       	call   801039b0 <myproc>
80105a86:	8b 40 24             	mov    0x24(%eax),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	74 11                	je     80105a9e <trap+0xfe>
80105a8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a91:	83 e0 03             	and    $0x3,%eax
80105a94:	66 83 f8 03          	cmp    $0x3,%ax
80105a98:	0f 84 03 01 00 00    	je     80105ba1 <trap+0x201>
    exit();
}
80105a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa1:	5b                   	pop    %ebx
80105aa2:	5e                   	pop    %esi
80105aa3:	5f                   	pop    %edi
80105aa4:	5d                   	pop    %ebp
80105aa5:	c3                   	ret    
    ideintr();
80105aa6:	e8 35 c7 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105aab:	e8 60 ce ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ab0:	e8 fb de ff ff       	call   801039b0 <myproc>
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	75 8a                	jne    80105a43 <trap+0xa3>
80105ab9:	eb a5                	jmp    80105a60 <trap+0xc0>
    if(cpuid() == 0){
80105abb:	e8 d0 de ff ff       	call   80103990 <cpuid>
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	75 e7                	jne    80105aab <trap+0x10b>
      acquire(&tickslock);
80105ac4:	83 ec 0c             	sub    $0xc,%esp
80105ac7:	68 00 f6 14 80       	push   $0x8014f600
80105acc:	e8 df ea ff ff       	call   801045b0 <acquire>
      wakeup(&ticks);
80105ad1:	c7 04 24 40 fe 14 80 	movl   $0x8014fe40,(%esp)
      ticks++;
80105ad8:	83 05 40 fe 14 80 01 	addl   $0x1,0x8014fe40
      wakeup(&ticks);
80105adf:	e8 4c e6 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
80105ae4:	c7 04 24 00 f6 14 80 	movl   $0x8014f600,(%esp)
80105aeb:	e8 80 eb ff ff       	call   80104670 <release>
80105af0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105af3:	eb b6                	jmp    80105aab <trap+0x10b>
    kbdintr();
80105af5:	e8 d6 cc ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105afa:	e8 11 ce ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aff:	e8 ac de ff ff       	call   801039b0 <myproc>
80105b04:	85 c0                	test   %eax,%eax
80105b06:	0f 85 37 ff ff ff    	jne    80105a43 <trap+0xa3>
80105b0c:	e9 4f ff ff ff       	jmp    80105a60 <trap+0xc0>
    uartintr();
80105b11:	e8 4a 02 00 00       	call   80105d60 <uartintr>
    lapiceoi();
80105b16:	e8 f5 cd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b1b:	e8 90 de ff ff       	call   801039b0 <myproc>
80105b20:	85 c0                	test   %eax,%eax
80105b22:	0f 85 1b ff ff ff    	jne    80105a43 <trap+0xa3>
80105b28:	e9 33 ff ff ff       	jmp    80105a60 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b2d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b30:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b34:	e8 57 de ff ff       	call   80103990 <cpuid>
80105b39:	57                   	push   %edi
80105b3a:	56                   	push   %esi
80105b3b:	50                   	push   %eax
80105b3c:	68 c4 78 10 80       	push   $0x801078c4
80105b41:	e8 6a ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b46:	e8 c5 cd ff ff       	call   80102910 <lapiceoi>
    break;
80105b4b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b4e:	e8 5d de ff ff       	call   801039b0 <myproc>
80105b53:	85 c0                	test   %eax,%eax
80105b55:	0f 85 e8 fe ff ff    	jne    80105a43 <trap+0xa3>
80105b5b:	e9 00 ff ff ff       	jmp    80105a60 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105b60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b64:	0f 85 0e ff ff ff    	jne    80105a78 <trap+0xd8>
    yield();
80105b6a:	e8 b1 e3 ff ff       	call   80103f20 <yield>
80105b6f:	e9 04 ff ff ff       	jmp    80105a78 <trap+0xd8>
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b78:	e8 33 de ff ff       	call   801039b0 <myproc>
80105b7d:	8b 70 24             	mov    0x24(%eax),%esi
80105b80:	85 f6                	test   %esi,%esi
80105b82:	75 3c                	jne    80105bc0 <trap+0x220>
    myproc()->tf = tf;
80105b84:	e8 27 de ff ff       	call   801039b0 <myproc>
80105b89:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b8c:	e8 ff ee ff ff       	call   80104a90 <syscall>
    if(myproc()->killed)
80105b91:	e8 1a de ff ff       	call   801039b0 <myproc>
80105b96:	8b 48 24             	mov    0x24(%eax),%ecx
80105b99:	85 c9                	test   %ecx,%ecx
80105b9b:	0f 84 fd fe ff ff    	je     80105a9e <trap+0xfe>
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
      exit();
80105ba8:	e9 33 e2 ff ff       	jmp    80103de0 <exit>
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105bb0:	e8 2b e2 ff ff       	call   80103de0 <exit>
80105bb5:	e9 a6 fe ff ff       	jmp    80105a60 <trap+0xc0>
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105bc0:	e8 1b e2 ff ff       	call   80103de0 <exit>
80105bc5:	eb bd                	jmp    80105b84 <trap+0x1e4>
80105bc7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bca:	e8 c1 dd ff ff       	call   80103990 <cpuid>
80105bcf:	83 ec 0c             	sub    $0xc,%esp
80105bd2:	56                   	push   %esi
80105bd3:	57                   	push   %edi
80105bd4:	50                   	push   %eax
80105bd5:	ff 73 30             	pushl  0x30(%ebx)
80105bd8:	68 e8 78 10 80       	push   $0x801078e8
80105bdd:	e8 ce aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105be2:	83 c4 14             	add    $0x14,%esp
80105be5:	68 be 78 10 80       	push   $0x801078be
80105bea:	e8 a1 a7 ff ff       	call   80100390 <panic>
80105bef:	90                   	nop

80105bf0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105bf4:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	74 1b                	je     80105c18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bfd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c02:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c03:	a8 01                	test   $0x1,%al
80105c05:	74 11                	je     80105c18 <uartgetc+0x28>
80105c07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c0c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c0d:	0f b6 c0             	movzbl %al,%eax
80105c10:	c3                   	ret    
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c1d:	c3                   	ret    
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <uartputc.part.0>:
uartputc(int c)
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	89 c7                	mov    %eax,%edi
80105c26:	56                   	push   %esi
80105c27:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c2c:	53                   	push   %ebx
80105c2d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c32:	83 ec 0c             	sub    $0xc,%esp
80105c35:	eb 1b                	jmp    80105c52 <uartputc.part.0+0x32>
80105c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	6a 0a                	push   $0xa
80105c45:	e8 e6 cc ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	83 eb 01             	sub    $0x1,%ebx
80105c50:	74 07                	je     80105c59 <uartputc.part.0+0x39>
80105c52:	89 f2                	mov    %esi,%edx
80105c54:	ec                   	in     (%dx),%al
80105c55:	a8 20                	test   $0x20,%al
80105c57:	74 e7                	je     80105c40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c5e:	89 f8                	mov    %edi,%eax
80105c60:	ee                   	out    %al,(%dx)
}
80105c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c64:	5b                   	pop    %ebx
80105c65:	5e                   	pop    %esi
80105c66:	5f                   	pop    %edi
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c70 <uartinit>:
{
80105c70:	f3 0f 1e fb          	endbr32 
80105c74:	55                   	push   %ebp
80105c75:	31 c9                	xor    %ecx,%ecx
80105c77:	89 c8                	mov    %ecx,%eax
80105c79:	89 e5                	mov    %esp,%ebp
80105c7b:	57                   	push   %edi
80105c7c:	56                   	push   %esi
80105c7d:	53                   	push   %ebx
80105c7e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c83:	89 da                	mov    %ebx,%edx
80105c85:	83 ec 0c             	sub    $0xc,%esp
80105c88:	ee                   	out    %al,(%dx)
80105c89:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c8e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c93:	89 fa                	mov    %edi,%edx
80105c95:	ee                   	out    %al,(%dx)
80105c96:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c9b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ca0:	ee                   	out    %al,(%dx)
80105ca1:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ca6:	89 c8                	mov    %ecx,%eax
80105ca8:	89 f2                	mov    %esi,%edx
80105caa:	ee                   	out    %al,(%dx)
80105cab:	b8 03 00 00 00       	mov    $0x3,%eax
80105cb0:	89 fa                	mov    %edi,%edx
80105cb2:	ee                   	out    %al,(%dx)
80105cb3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cb8:	89 c8                	mov    %ecx,%eax
80105cba:	ee                   	out    %al,(%dx)
80105cbb:	b8 01 00 00 00       	mov    $0x1,%eax
80105cc0:	89 f2                	mov    %esi,%edx
80105cc2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cc3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cc8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105cc9:	3c ff                	cmp    $0xff,%al
80105ccb:	74 52                	je     80105d1f <uartinit+0xaf>
  uart = 1;
80105ccd:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105cd4:	00 00 00 
80105cd7:	89 da                	mov    %ebx,%edx
80105cd9:	ec                   	in     (%dx),%al
80105cda:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cdf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ce0:	83 ec 08             	sub    $0x8,%esp
80105ce3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105ce8:	bb e0 79 10 80       	mov    $0x801079e0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ced:	6a 00                	push   $0x0
80105cef:	6a 04                	push   $0x4
80105cf1:	e8 3a c7 ff ff       	call   80102430 <ioapicenable>
80105cf6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105cf9:	b8 78 00 00 00       	mov    $0x78,%eax
80105cfe:	eb 04                	jmp    80105d04 <uartinit+0x94>
80105d00:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105d04:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d0a:	85 d2                	test   %edx,%edx
80105d0c:	74 08                	je     80105d16 <uartinit+0xa6>
    uartputc(*p);
80105d0e:	0f be c0             	movsbl %al,%eax
80105d11:	e8 0a ff ff ff       	call   80105c20 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105d16:	89 f0                	mov    %esi,%eax
80105d18:	83 c3 01             	add    $0x1,%ebx
80105d1b:	84 c0                	test   %al,%al
80105d1d:	75 e1                	jne    80105d00 <uartinit+0x90>
}
80105d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d22:	5b                   	pop    %ebx
80105d23:	5e                   	pop    %esi
80105d24:	5f                   	pop    %edi
80105d25:	5d                   	pop    %ebp
80105d26:	c3                   	ret    
80105d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <uartputc>:
{
80105d30:	f3 0f 1e fb          	endbr32 
80105d34:	55                   	push   %ebp
  if(!uart)
80105d35:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d3b:	89 e5                	mov    %esp,%ebp
80105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105d40:	85 d2                	test   %edx,%edx
80105d42:	74 0c                	je     80105d50 <uartputc+0x20>
}
80105d44:	5d                   	pop    %ebp
80105d45:	e9 d6 fe ff ff       	jmp    80105c20 <uartputc.part.0>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d50:	5d                   	pop    %ebp
80105d51:	c3                   	ret    
80105d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <uartintr>:

void
uartintr(void)
{
80105d60:	f3 0f 1e fb          	endbr32 
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d6a:	68 f0 5b 10 80       	push   $0x80105bf0
80105d6f:	e8 ec aa ff ff       	call   80100860 <consoleintr>
}
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	c9                   	leave  
80105d78:	c3                   	ret    

80105d79 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $0
80105d7b:	6a 00                	push   $0x0
  jmp alltraps
80105d7d:	e9 3c fb ff ff       	jmp    801058be <alltraps>

80105d82 <vector1>:
.globl vector1
vector1:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $1
80105d84:	6a 01                	push   $0x1
  jmp alltraps
80105d86:	e9 33 fb ff ff       	jmp    801058be <alltraps>

80105d8b <vector2>:
.globl vector2
vector2:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $2
80105d8d:	6a 02                	push   $0x2
  jmp alltraps
80105d8f:	e9 2a fb ff ff       	jmp    801058be <alltraps>

80105d94 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $3
80105d96:	6a 03                	push   $0x3
  jmp alltraps
80105d98:	e9 21 fb ff ff       	jmp    801058be <alltraps>

80105d9d <vector4>:
.globl vector4
vector4:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $4
80105d9f:	6a 04                	push   $0x4
  jmp alltraps
80105da1:	e9 18 fb ff ff       	jmp    801058be <alltraps>

80105da6 <vector5>:
.globl vector5
vector5:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $5
80105da8:	6a 05                	push   $0x5
  jmp alltraps
80105daa:	e9 0f fb ff ff       	jmp    801058be <alltraps>

80105daf <vector6>:
.globl vector6
vector6:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $6
80105db1:	6a 06                	push   $0x6
  jmp alltraps
80105db3:	e9 06 fb ff ff       	jmp    801058be <alltraps>

80105db8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $7
80105dba:	6a 07                	push   $0x7
  jmp alltraps
80105dbc:	e9 fd fa ff ff       	jmp    801058be <alltraps>

80105dc1 <vector8>:
.globl vector8
vector8:
  pushl $8
80105dc1:	6a 08                	push   $0x8
  jmp alltraps
80105dc3:	e9 f6 fa ff ff       	jmp    801058be <alltraps>

80105dc8 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $9
80105dca:	6a 09                	push   $0x9
  jmp alltraps
80105dcc:	e9 ed fa ff ff       	jmp    801058be <alltraps>

80105dd1 <vector10>:
.globl vector10
vector10:
  pushl $10
80105dd1:	6a 0a                	push   $0xa
  jmp alltraps
80105dd3:	e9 e6 fa ff ff       	jmp    801058be <alltraps>

80105dd8 <vector11>:
.globl vector11
vector11:
  pushl $11
80105dd8:	6a 0b                	push   $0xb
  jmp alltraps
80105dda:	e9 df fa ff ff       	jmp    801058be <alltraps>

80105ddf <vector12>:
.globl vector12
vector12:
  pushl $12
80105ddf:	6a 0c                	push   $0xc
  jmp alltraps
80105de1:	e9 d8 fa ff ff       	jmp    801058be <alltraps>

80105de6 <vector13>:
.globl vector13
vector13:
  pushl $13
80105de6:	6a 0d                	push   $0xd
  jmp alltraps
80105de8:	e9 d1 fa ff ff       	jmp    801058be <alltraps>

80105ded <vector14>:
.globl vector14
vector14:
  pushl $14
80105ded:	6a 0e                	push   $0xe
  jmp alltraps
80105def:	e9 ca fa ff ff       	jmp    801058be <alltraps>

80105df4 <vector15>:
.globl vector15
vector15:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $15
80105df6:	6a 0f                	push   $0xf
  jmp alltraps
80105df8:	e9 c1 fa ff ff       	jmp    801058be <alltraps>

80105dfd <vector16>:
.globl vector16
vector16:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $16
80105dff:	6a 10                	push   $0x10
  jmp alltraps
80105e01:	e9 b8 fa ff ff       	jmp    801058be <alltraps>

80105e06 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e06:	6a 11                	push   $0x11
  jmp alltraps
80105e08:	e9 b1 fa ff ff       	jmp    801058be <alltraps>

80105e0d <vector18>:
.globl vector18
vector18:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $18
80105e0f:	6a 12                	push   $0x12
  jmp alltraps
80105e11:	e9 a8 fa ff ff       	jmp    801058be <alltraps>

80105e16 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $19
80105e18:	6a 13                	push   $0x13
  jmp alltraps
80105e1a:	e9 9f fa ff ff       	jmp    801058be <alltraps>

80105e1f <vector20>:
.globl vector20
vector20:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $20
80105e21:	6a 14                	push   $0x14
  jmp alltraps
80105e23:	e9 96 fa ff ff       	jmp    801058be <alltraps>

80105e28 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $21
80105e2a:	6a 15                	push   $0x15
  jmp alltraps
80105e2c:	e9 8d fa ff ff       	jmp    801058be <alltraps>

80105e31 <vector22>:
.globl vector22
vector22:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $22
80105e33:	6a 16                	push   $0x16
  jmp alltraps
80105e35:	e9 84 fa ff ff       	jmp    801058be <alltraps>

80105e3a <vector23>:
.globl vector23
vector23:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $23
80105e3c:	6a 17                	push   $0x17
  jmp alltraps
80105e3e:	e9 7b fa ff ff       	jmp    801058be <alltraps>

80105e43 <vector24>:
.globl vector24
vector24:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $24
80105e45:	6a 18                	push   $0x18
  jmp alltraps
80105e47:	e9 72 fa ff ff       	jmp    801058be <alltraps>

80105e4c <vector25>:
.globl vector25
vector25:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $25
80105e4e:	6a 19                	push   $0x19
  jmp alltraps
80105e50:	e9 69 fa ff ff       	jmp    801058be <alltraps>

80105e55 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $26
80105e57:	6a 1a                	push   $0x1a
  jmp alltraps
80105e59:	e9 60 fa ff ff       	jmp    801058be <alltraps>

80105e5e <vector27>:
.globl vector27
vector27:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $27
80105e60:	6a 1b                	push   $0x1b
  jmp alltraps
80105e62:	e9 57 fa ff ff       	jmp    801058be <alltraps>

80105e67 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $28
80105e69:	6a 1c                	push   $0x1c
  jmp alltraps
80105e6b:	e9 4e fa ff ff       	jmp    801058be <alltraps>

80105e70 <vector29>:
.globl vector29
vector29:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $29
80105e72:	6a 1d                	push   $0x1d
  jmp alltraps
80105e74:	e9 45 fa ff ff       	jmp    801058be <alltraps>

80105e79 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $30
80105e7b:	6a 1e                	push   $0x1e
  jmp alltraps
80105e7d:	e9 3c fa ff ff       	jmp    801058be <alltraps>

80105e82 <vector31>:
.globl vector31
vector31:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $31
80105e84:	6a 1f                	push   $0x1f
  jmp alltraps
80105e86:	e9 33 fa ff ff       	jmp    801058be <alltraps>

80105e8b <vector32>:
.globl vector32
vector32:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $32
80105e8d:	6a 20                	push   $0x20
  jmp alltraps
80105e8f:	e9 2a fa ff ff       	jmp    801058be <alltraps>

80105e94 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $33
80105e96:	6a 21                	push   $0x21
  jmp alltraps
80105e98:	e9 21 fa ff ff       	jmp    801058be <alltraps>

80105e9d <vector34>:
.globl vector34
vector34:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $34
80105e9f:	6a 22                	push   $0x22
  jmp alltraps
80105ea1:	e9 18 fa ff ff       	jmp    801058be <alltraps>

80105ea6 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $35
80105ea8:	6a 23                	push   $0x23
  jmp alltraps
80105eaa:	e9 0f fa ff ff       	jmp    801058be <alltraps>

80105eaf <vector36>:
.globl vector36
vector36:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $36
80105eb1:	6a 24                	push   $0x24
  jmp alltraps
80105eb3:	e9 06 fa ff ff       	jmp    801058be <alltraps>

80105eb8 <vector37>:
.globl vector37
vector37:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $37
80105eba:	6a 25                	push   $0x25
  jmp alltraps
80105ebc:	e9 fd f9 ff ff       	jmp    801058be <alltraps>

80105ec1 <vector38>:
.globl vector38
vector38:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $38
80105ec3:	6a 26                	push   $0x26
  jmp alltraps
80105ec5:	e9 f4 f9 ff ff       	jmp    801058be <alltraps>

80105eca <vector39>:
.globl vector39
vector39:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $39
80105ecc:	6a 27                	push   $0x27
  jmp alltraps
80105ece:	e9 eb f9 ff ff       	jmp    801058be <alltraps>

80105ed3 <vector40>:
.globl vector40
vector40:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $40
80105ed5:	6a 28                	push   $0x28
  jmp alltraps
80105ed7:	e9 e2 f9 ff ff       	jmp    801058be <alltraps>

80105edc <vector41>:
.globl vector41
vector41:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $41
80105ede:	6a 29                	push   $0x29
  jmp alltraps
80105ee0:	e9 d9 f9 ff ff       	jmp    801058be <alltraps>

80105ee5 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $42
80105ee7:	6a 2a                	push   $0x2a
  jmp alltraps
80105ee9:	e9 d0 f9 ff ff       	jmp    801058be <alltraps>

80105eee <vector43>:
.globl vector43
vector43:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $43
80105ef0:	6a 2b                	push   $0x2b
  jmp alltraps
80105ef2:	e9 c7 f9 ff ff       	jmp    801058be <alltraps>

80105ef7 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $44
80105ef9:	6a 2c                	push   $0x2c
  jmp alltraps
80105efb:	e9 be f9 ff ff       	jmp    801058be <alltraps>

80105f00 <vector45>:
.globl vector45
vector45:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $45
80105f02:	6a 2d                	push   $0x2d
  jmp alltraps
80105f04:	e9 b5 f9 ff ff       	jmp    801058be <alltraps>

80105f09 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $46
80105f0b:	6a 2e                	push   $0x2e
  jmp alltraps
80105f0d:	e9 ac f9 ff ff       	jmp    801058be <alltraps>

80105f12 <vector47>:
.globl vector47
vector47:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $47
80105f14:	6a 2f                	push   $0x2f
  jmp alltraps
80105f16:	e9 a3 f9 ff ff       	jmp    801058be <alltraps>

80105f1b <vector48>:
.globl vector48
vector48:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $48
80105f1d:	6a 30                	push   $0x30
  jmp alltraps
80105f1f:	e9 9a f9 ff ff       	jmp    801058be <alltraps>

80105f24 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $49
80105f26:	6a 31                	push   $0x31
  jmp alltraps
80105f28:	e9 91 f9 ff ff       	jmp    801058be <alltraps>

80105f2d <vector50>:
.globl vector50
vector50:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $50
80105f2f:	6a 32                	push   $0x32
  jmp alltraps
80105f31:	e9 88 f9 ff ff       	jmp    801058be <alltraps>

80105f36 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $51
80105f38:	6a 33                	push   $0x33
  jmp alltraps
80105f3a:	e9 7f f9 ff ff       	jmp    801058be <alltraps>

80105f3f <vector52>:
.globl vector52
vector52:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $52
80105f41:	6a 34                	push   $0x34
  jmp alltraps
80105f43:	e9 76 f9 ff ff       	jmp    801058be <alltraps>

80105f48 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $53
80105f4a:	6a 35                	push   $0x35
  jmp alltraps
80105f4c:	e9 6d f9 ff ff       	jmp    801058be <alltraps>

80105f51 <vector54>:
.globl vector54
vector54:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $54
80105f53:	6a 36                	push   $0x36
  jmp alltraps
80105f55:	e9 64 f9 ff ff       	jmp    801058be <alltraps>

80105f5a <vector55>:
.globl vector55
vector55:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $55
80105f5c:	6a 37                	push   $0x37
  jmp alltraps
80105f5e:	e9 5b f9 ff ff       	jmp    801058be <alltraps>

80105f63 <vector56>:
.globl vector56
vector56:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $56
80105f65:	6a 38                	push   $0x38
  jmp alltraps
80105f67:	e9 52 f9 ff ff       	jmp    801058be <alltraps>

80105f6c <vector57>:
.globl vector57
vector57:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $57
80105f6e:	6a 39                	push   $0x39
  jmp alltraps
80105f70:	e9 49 f9 ff ff       	jmp    801058be <alltraps>

80105f75 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $58
80105f77:	6a 3a                	push   $0x3a
  jmp alltraps
80105f79:	e9 40 f9 ff ff       	jmp    801058be <alltraps>

80105f7e <vector59>:
.globl vector59
vector59:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $59
80105f80:	6a 3b                	push   $0x3b
  jmp alltraps
80105f82:	e9 37 f9 ff ff       	jmp    801058be <alltraps>

80105f87 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $60
80105f89:	6a 3c                	push   $0x3c
  jmp alltraps
80105f8b:	e9 2e f9 ff ff       	jmp    801058be <alltraps>

80105f90 <vector61>:
.globl vector61
vector61:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $61
80105f92:	6a 3d                	push   $0x3d
  jmp alltraps
80105f94:	e9 25 f9 ff ff       	jmp    801058be <alltraps>

80105f99 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $62
80105f9b:	6a 3e                	push   $0x3e
  jmp alltraps
80105f9d:	e9 1c f9 ff ff       	jmp    801058be <alltraps>

80105fa2 <vector63>:
.globl vector63
vector63:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $63
80105fa4:	6a 3f                	push   $0x3f
  jmp alltraps
80105fa6:	e9 13 f9 ff ff       	jmp    801058be <alltraps>

80105fab <vector64>:
.globl vector64
vector64:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $64
80105fad:	6a 40                	push   $0x40
  jmp alltraps
80105faf:	e9 0a f9 ff ff       	jmp    801058be <alltraps>

80105fb4 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $65
80105fb6:	6a 41                	push   $0x41
  jmp alltraps
80105fb8:	e9 01 f9 ff ff       	jmp    801058be <alltraps>

80105fbd <vector66>:
.globl vector66
vector66:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $66
80105fbf:	6a 42                	push   $0x42
  jmp alltraps
80105fc1:	e9 f8 f8 ff ff       	jmp    801058be <alltraps>

80105fc6 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $67
80105fc8:	6a 43                	push   $0x43
  jmp alltraps
80105fca:	e9 ef f8 ff ff       	jmp    801058be <alltraps>

80105fcf <vector68>:
.globl vector68
vector68:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $68
80105fd1:	6a 44                	push   $0x44
  jmp alltraps
80105fd3:	e9 e6 f8 ff ff       	jmp    801058be <alltraps>

80105fd8 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $69
80105fda:	6a 45                	push   $0x45
  jmp alltraps
80105fdc:	e9 dd f8 ff ff       	jmp    801058be <alltraps>

80105fe1 <vector70>:
.globl vector70
vector70:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $70
80105fe3:	6a 46                	push   $0x46
  jmp alltraps
80105fe5:	e9 d4 f8 ff ff       	jmp    801058be <alltraps>

80105fea <vector71>:
.globl vector71
vector71:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $71
80105fec:	6a 47                	push   $0x47
  jmp alltraps
80105fee:	e9 cb f8 ff ff       	jmp    801058be <alltraps>

80105ff3 <vector72>:
.globl vector72
vector72:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $72
80105ff5:	6a 48                	push   $0x48
  jmp alltraps
80105ff7:	e9 c2 f8 ff ff       	jmp    801058be <alltraps>

80105ffc <vector73>:
.globl vector73
vector73:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $73
80105ffe:	6a 49                	push   $0x49
  jmp alltraps
80106000:	e9 b9 f8 ff ff       	jmp    801058be <alltraps>

80106005 <vector74>:
.globl vector74
vector74:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $74
80106007:	6a 4a                	push   $0x4a
  jmp alltraps
80106009:	e9 b0 f8 ff ff       	jmp    801058be <alltraps>

8010600e <vector75>:
.globl vector75
vector75:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $75
80106010:	6a 4b                	push   $0x4b
  jmp alltraps
80106012:	e9 a7 f8 ff ff       	jmp    801058be <alltraps>

80106017 <vector76>:
.globl vector76
vector76:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $76
80106019:	6a 4c                	push   $0x4c
  jmp alltraps
8010601b:	e9 9e f8 ff ff       	jmp    801058be <alltraps>

80106020 <vector77>:
.globl vector77
vector77:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $77
80106022:	6a 4d                	push   $0x4d
  jmp alltraps
80106024:	e9 95 f8 ff ff       	jmp    801058be <alltraps>

80106029 <vector78>:
.globl vector78
vector78:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $78
8010602b:	6a 4e                	push   $0x4e
  jmp alltraps
8010602d:	e9 8c f8 ff ff       	jmp    801058be <alltraps>

80106032 <vector79>:
.globl vector79
vector79:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $79
80106034:	6a 4f                	push   $0x4f
  jmp alltraps
80106036:	e9 83 f8 ff ff       	jmp    801058be <alltraps>

8010603b <vector80>:
.globl vector80
vector80:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $80
8010603d:	6a 50                	push   $0x50
  jmp alltraps
8010603f:	e9 7a f8 ff ff       	jmp    801058be <alltraps>

80106044 <vector81>:
.globl vector81
vector81:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $81
80106046:	6a 51                	push   $0x51
  jmp alltraps
80106048:	e9 71 f8 ff ff       	jmp    801058be <alltraps>

8010604d <vector82>:
.globl vector82
vector82:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $82
8010604f:	6a 52                	push   $0x52
  jmp alltraps
80106051:	e9 68 f8 ff ff       	jmp    801058be <alltraps>

80106056 <vector83>:
.globl vector83
vector83:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $83
80106058:	6a 53                	push   $0x53
  jmp alltraps
8010605a:	e9 5f f8 ff ff       	jmp    801058be <alltraps>

8010605f <vector84>:
.globl vector84
vector84:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $84
80106061:	6a 54                	push   $0x54
  jmp alltraps
80106063:	e9 56 f8 ff ff       	jmp    801058be <alltraps>

80106068 <vector85>:
.globl vector85
vector85:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $85
8010606a:	6a 55                	push   $0x55
  jmp alltraps
8010606c:	e9 4d f8 ff ff       	jmp    801058be <alltraps>

80106071 <vector86>:
.globl vector86
vector86:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $86
80106073:	6a 56                	push   $0x56
  jmp alltraps
80106075:	e9 44 f8 ff ff       	jmp    801058be <alltraps>

8010607a <vector87>:
.globl vector87
vector87:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $87
8010607c:	6a 57                	push   $0x57
  jmp alltraps
8010607e:	e9 3b f8 ff ff       	jmp    801058be <alltraps>

80106083 <vector88>:
.globl vector88
vector88:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $88
80106085:	6a 58                	push   $0x58
  jmp alltraps
80106087:	e9 32 f8 ff ff       	jmp    801058be <alltraps>

8010608c <vector89>:
.globl vector89
vector89:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $89
8010608e:	6a 59                	push   $0x59
  jmp alltraps
80106090:	e9 29 f8 ff ff       	jmp    801058be <alltraps>

80106095 <vector90>:
.globl vector90
vector90:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $90
80106097:	6a 5a                	push   $0x5a
  jmp alltraps
80106099:	e9 20 f8 ff ff       	jmp    801058be <alltraps>

8010609e <vector91>:
.globl vector91
vector91:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $91
801060a0:	6a 5b                	push   $0x5b
  jmp alltraps
801060a2:	e9 17 f8 ff ff       	jmp    801058be <alltraps>

801060a7 <vector92>:
.globl vector92
vector92:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $92
801060a9:	6a 5c                	push   $0x5c
  jmp alltraps
801060ab:	e9 0e f8 ff ff       	jmp    801058be <alltraps>

801060b0 <vector93>:
.globl vector93
vector93:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $93
801060b2:	6a 5d                	push   $0x5d
  jmp alltraps
801060b4:	e9 05 f8 ff ff       	jmp    801058be <alltraps>

801060b9 <vector94>:
.globl vector94
vector94:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $94
801060bb:	6a 5e                	push   $0x5e
  jmp alltraps
801060bd:	e9 fc f7 ff ff       	jmp    801058be <alltraps>

801060c2 <vector95>:
.globl vector95
vector95:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $95
801060c4:	6a 5f                	push   $0x5f
  jmp alltraps
801060c6:	e9 f3 f7 ff ff       	jmp    801058be <alltraps>

801060cb <vector96>:
.globl vector96
vector96:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $96
801060cd:	6a 60                	push   $0x60
  jmp alltraps
801060cf:	e9 ea f7 ff ff       	jmp    801058be <alltraps>

801060d4 <vector97>:
.globl vector97
vector97:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $97
801060d6:	6a 61                	push   $0x61
  jmp alltraps
801060d8:	e9 e1 f7 ff ff       	jmp    801058be <alltraps>

801060dd <vector98>:
.globl vector98
vector98:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $98
801060df:	6a 62                	push   $0x62
  jmp alltraps
801060e1:	e9 d8 f7 ff ff       	jmp    801058be <alltraps>

801060e6 <vector99>:
.globl vector99
vector99:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $99
801060e8:	6a 63                	push   $0x63
  jmp alltraps
801060ea:	e9 cf f7 ff ff       	jmp    801058be <alltraps>

801060ef <vector100>:
.globl vector100
vector100:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $100
801060f1:	6a 64                	push   $0x64
  jmp alltraps
801060f3:	e9 c6 f7 ff ff       	jmp    801058be <alltraps>

801060f8 <vector101>:
.globl vector101
vector101:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $101
801060fa:	6a 65                	push   $0x65
  jmp alltraps
801060fc:	e9 bd f7 ff ff       	jmp    801058be <alltraps>

80106101 <vector102>:
.globl vector102
vector102:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $102
80106103:	6a 66                	push   $0x66
  jmp alltraps
80106105:	e9 b4 f7 ff ff       	jmp    801058be <alltraps>

8010610a <vector103>:
.globl vector103
vector103:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $103
8010610c:	6a 67                	push   $0x67
  jmp alltraps
8010610e:	e9 ab f7 ff ff       	jmp    801058be <alltraps>

80106113 <vector104>:
.globl vector104
vector104:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $104
80106115:	6a 68                	push   $0x68
  jmp alltraps
80106117:	e9 a2 f7 ff ff       	jmp    801058be <alltraps>

8010611c <vector105>:
.globl vector105
vector105:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $105
8010611e:	6a 69                	push   $0x69
  jmp alltraps
80106120:	e9 99 f7 ff ff       	jmp    801058be <alltraps>

80106125 <vector106>:
.globl vector106
vector106:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $106
80106127:	6a 6a                	push   $0x6a
  jmp alltraps
80106129:	e9 90 f7 ff ff       	jmp    801058be <alltraps>

8010612e <vector107>:
.globl vector107
vector107:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $107
80106130:	6a 6b                	push   $0x6b
  jmp alltraps
80106132:	e9 87 f7 ff ff       	jmp    801058be <alltraps>

80106137 <vector108>:
.globl vector108
vector108:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $108
80106139:	6a 6c                	push   $0x6c
  jmp alltraps
8010613b:	e9 7e f7 ff ff       	jmp    801058be <alltraps>

80106140 <vector109>:
.globl vector109
vector109:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $109
80106142:	6a 6d                	push   $0x6d
  jmp alltraps
80106144:	e9 75 f7 ff ff       	jmp    801058be <alltraps>

80106149 <vector110>:
.globl vector110
vector110:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $110
8010614b:	6a 6e                	push   $0x6e
  jmp alltraps
8010614d:	e9 6c f7 ff ff       	jmp    801058be <alltraps>

80106152 <vector111>:
.globl vector111
vector111:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $111
80106154:	6a 6f                	push   $0x6f
  jmp alltraps
80106156:	e9 63 f7 ff ff       	jmp    801058be <alltraps>

8010615b <vector112>:
.globl vector112
vector112:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $112
8010615d:	6a 70                	push   $0x70
  jmp alltraps
8010615f:	e9 5a f7 ff ff       	jmp    801058be <alltraps>

80106164 <vector113>:
.globl vector113
vector113:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $113
80106166:	6a 71                	push   $0x71
  jmp alltraps
80106168:	e9 51 f7 ff ff       	jmp    801058be <alltraps>

8010616d <vector114>:
.globl vector114
vector114:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $114
8010616f:	6a 72                	push   $0x72
  jmp alltraps
80106171:	e9 48 f7 ff ff       	jmp    801058be <alltraps>

80106176 <vector115>:
.globl vector115
vector115:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $115
80106178:	6a 73                	push   $0x73
  jmp alltraps
8010617a:	e9 3f f7 ff ff       	jmp    801058be <alltraps>

8010617f <vector116>:
.globl vector116
vector116:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $116
80106181:	6a 74                	push   $0x74
  jmp alltraps
80106183:	e9 36 f7 ff ff       	jmp    801058be <alltraps>

80106188 <vector117>:
.globl vector117
vector117:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $117
8010618a:	6a 75                	push   $0x75
  jmp alltraps
8010618c:	e9 2d f7 ff ff       	jmp    801058be <alltraps>

80106191 <vector118>:
.globl vector118
vector118:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $118
80106193:	6a 76                	push   $0x76
  jmp alltraps
80106195:	e9 24 f7 ff ff       	jmp    801058be <alltraps>

8010619a <vector119>:
.globl vector119
vector119:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $119
8010619c:	6a 77                	push   $0x77
  jmp alltraps
8010619e:	e9 1b f7 ff ff       	jmp    801058be <alltraps>

801061a3 <vector120>:
.globl vector120
vector120:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $120
801061a5:	6a 78                	push   $0x78
  jmp alltraps
801061a7:	e9 12 f7 ff ff       	jmp    801058be <alltraps>

801061ac <vector121>:
.globl vector121
vector121:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $121
801061ae:	6a 79                	push   $0x79
  jmp alltraps
801061b0:	e9 09 f7 ff ff       	jmp    801058be <alltraps>

801061b5 <vector122>:
.globl vector122
vector122:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $122
801061b7:	6a 7a                	push   $0x7a
  jmp alltraps
801061b9:	e9 00 f7 ff ff       	jmp    801058be <alltraps>

801061be <vector123>:
.globl vector123
vector123:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $123
801061c0:	6a 7b                	push   $0x7b
  jmp alltraps
801061c2:	e9 f7 f6 ff ff       	jmp    801058be <alltraps>

801061c7 <vector124>:
.globl vector124
vector124:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $124
801061c9:	6a 7c                	push   $0x7c
  jmp alltraps
801061cb:	e9 ee f6 ff ff       	jmp    801058be <alltraps>

801061d0 <vector125>:
.globl vector125
vector125:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $125
801061d2:	6a 7d                	push   $0x7d
  jmp alltraps
801061d4:	e9 e5 f6 ff ff       	jmp    801058be <alltraps>

801061d9 <vector126>:
.globl vector126
vector126:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $126
801061db:	6a 7e                	push   $0x7e
  jmp alltraps
801061dd:	e9 dc f6 ff ff       	jmp    801058be <alltraps>

801061e2 <vector127>:
.globl vector127
vector127:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $127
801061e4:	6a 7f                	push   $0x7f
  jmp alltraps
801061e6:	e9 d3 f6 ff ff       	jmp    801058be <alltraps>

801061eb <vector128>:
.globl vector128
vector128:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $128
801061ed:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061f2:	e9 c7 f6 ff ff       	jmp    801058be <alltraps>

801061f7 <vector129>:
.globl vector129
vector129:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $129
801061f9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061fe:	e9 bb f6 ff ff       	jmp    801058be <alltraps>

80106203 <vector130>:
.globl vector130
vector130:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $130
80106205:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010620a:	e9 af f6 ff ff       	jmp    801058be <alltraps>

8010620f <vector131>:
.globl vector131
vector131:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $131
80106211:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106216:	e9 a3 f6 ff ff       	jmp    801058be <alltraps>

8010621b <vector132>:
.globl vector132
vector132:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $132
8010621d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106222:	e9 97 f6 ff ff       	jmp    801058be <alltraps>

80106227 <vector133>:
.globl vector133
vector133:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $133
80106229:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010622e:	e9 8b f6 ff ff       	jmp    801058be <alltraps>

80106233 <vector134>:
.globl vector134
vector134:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $134
80106235:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010623a:	e9 7f f6 ff ff       	jmp    801058be <alltraps>

8010623f <vector135>:
.globl vector135
vector135:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $135
80106241:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106246:	e9 73 f6 ff ff       	jmp    801058be <alltraps>

8010624b <vector136>:
.globl vector136
vector136:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $136
8010624d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106252:	e9 67 f6 ff ff       	jmp    801058be <alltraps>

80106257 <vector137>:
.globl vector137
vector137:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $137
80106259:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010625e:	e9 5b f6 ff ff       	jmp    801058be <alltraps>

80106263 <vector138>:
.globl vector138
vector138:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $138
80106265:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010626a:	e9 4f f6 ff ff       	jmp    801058be <alltraps>

8010626f <vector139>:
.globl vector139
vector139:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $139
80106271:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106276:	e9 43 f6 ff ff       	jmp    801058be <alltraps>

8010627b <vector140>:
.globl vector140
vector140:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $140
8010627d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106282:	e9 37 f6 ff ff       	jmp    801058be <alltraps>

80106287 <vector141>:
.globl vector141
vector141:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $141
80106289:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010628e:	e9 2b f6 ff ff       	jmp    801058be <alltraps>

80106293 <vector142>:
.globl vector142
vector142:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $142
80106295:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010629a:	e9 1f f6 ff ff       	jmp    801058be <alltraps>

8010629f <vector143>:
.globl vector143
vector143:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $143
801062a1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062a6:	e9 13 f6 ff ff       	jmp    801058be <alltraps>

801062ab <vector144>:
.globl vector144
vector144:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $144
801062ad:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062b2:	e9 07 f6 ff ff       	jmp    801058be <alltraps>

801062b7 <vector145>:
.globl vector145
vector145:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $145
801062b9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062be:	e9 fb f5 ff ff       	jmp    801058be <alltraps>

801062c3 <vector146>:
.globl vector146
vector146:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $146
801062c5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062ca:	e9 ef f5 ff ff       	jmp    801058be <alltraps>

801062cf <vector147>:
.globl vector147
vector147:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $147
801062d1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062d6:	e9 e3 f5 ff ff       	jmp    801058be <alltraps>

801062db <vector148>:
.globl vector148
vector148:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $148
801062dd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062e2:	e9 d7 f5 ff ff       	jmp    801058be <alltraps>

801062e7 <vector149>:
.globl vector149
vector149:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $149
801062e9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062ee:	e9 cb f5 ff ff       	jmp    801058be <alltraps>

801062f3 <vector150>:
.globl vector150
vector150:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $150
801062f5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062fa:	e9 bf f5 ff ff       	jmp    801058be <alltraps>

801062ff <vector151>:
.globl vector151
vector151:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $151
80106301:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106306:	e9 b3 f5 ff ff       	jmp    801058be <alltraps>

8010630b <vector152>:
.globl vector152
vector152:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $152
8010630d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106312:	e9 a7 f5 ff ff       	jmp    801058be <alltraps>

80106317 <vector153>:
.globl vector153
vector153:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $153
80106319:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010631e:	e9 9b f5 ff ff       	jmp    801058be <alltraps>

80106323 <vector154>:
.globl vector154
vector154:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $154
80106325:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010632a:	e9 8f f5 ff ff       	jmp    801058be <alltraps>

8010632f <vector155>:
.globl vector155
vector155:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $155
80106331:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106336:	e9 83 f5 ff ff       	jmp    801058be <alltraps>

8010633b <vector156>:
.globl vector156
vector156:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $156
8010633d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106342:	e9 77 f5 ff ff       	jmp    801058be <alltraps>

80106347 <vector157>:
.globl vector157
vector157:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $157
80106349:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010634e:	e9 6b f5 ff ff       	jmp    801058be <alltraps>

80106353 <vector158>:
.globl vector158
vector158:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $158
80106355:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010635a:	e9 5f f5 ff ff       	jmp    801058be <alltraps>

8010635f <vector159>:
.globl vector159
vector159:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $159
80106361:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106366:	e9 53 f5 ff ff       	jmp    801058be <alltraps>

8010636b <vector160>:
.globl vector160
vector160:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $160
8010636d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106372:	e9 47 f5 ff ff       	jmp    801058be <alltraps>

80106377 <vector161>:
.globl vector161
vector161:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $161
80106379:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010637e:	e9 3b f5 ff ff       	jmp    801058be <alltraps>

80106383 <vector162>:
.globl vector162
vector162:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $162
80106385:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010638a:	e9 2f f5 ff ff       	jmp    801058be <alltraps>

8010638f <vector163>:
.globl vector163
vector163:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $163
80106391:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106396:	e9 23 f5 ff ff       	jmp    801058be <alltraps>

8010639b <vector164>:
.globl vector164
vector164:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $164
8010639d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063a2:	e9 17 f5 ff ff       	jmp    801058be <alltraps>

801063a7 <vector165>:
.globl vector165
vector165:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $165
801063a9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063ae:	e9 0b f5 ff ff       	jmp    801058be <alltraps>

801063b3 <vector166>:
.globl vector166
vector166:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $166
801063b5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063ba:	e9 ff f4 ff ff       	jmp    801058be <alltraps>

801063bf <vector167>:
.globl vector167
vector167:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $167
801063c1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063c6:	e9 f3 f4 ff ff       	jmp    801058be <alltraps>

801063cb <vector168>:
.globl vector168
vector168:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $168
801063cd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063d2:	e9 e7 f4 ff ff       	jmp    801058be <alltraps>

801063d7 <vector169>:
.globl vector169
vector169:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $169
801063d9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063de:	e9 db f4 ff ff       	jmp    801058be <alltraps>

801063e3 <vector170>:
.globl vector170
vector170:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $170
801063e5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063ea:	e9 cf f4 ff ff       	jmp    801058be <alltraps>

801063ef <vector171>:
.globl vector171
vector171:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $171
801063f1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063f6:	e9 c3 f4 ff ff       	jmp    801058be <alltraps>

801063fb <vector172>:
.globl vector172
vector172:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $172
801063fd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106402:	e9 b7 f4 ff ff       	jmp    801058be <alltraps>

80106407 <vector173>:
.globl vector173
vector173:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $173
80106409:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010640e:	e9 ab f4 ff ff       	jmp    801058be <alltraps>

80106413 <vector174>:
.globl vector174
vector174:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $174
80106415:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010641a:	e9 9f f4 ff ff       	jmp    801058be <alltraps>

8010641f <vector175>:
.globl vector175
vector175:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $175
80106421:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106426:	e9 93 f4 ff ff       	jmp    801058be <alltraps>

8010642b <vector176>:
.globl vector176
vector176:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $176
8010642d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106432:	e9 87 f4 ff ff       	jmp    801058be <alltraps>

80106437 <vector177>:
.globl vector177
vector177:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $177
80106439:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010643e:	e9 7b f4 ff ff       	jmp    801058be <alltraps>

80106443 <vector178>:
.globl vector178
vector178:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $178
80106445:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010644a:	e9 6f f4 ff ff       	jmp    801058be <alltraps>

8010644f <vector179>:
.globl vector179
vector179:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $179
80106451:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106456:	e9 63 f4 ff ff       	jmp    801058be <alltraps>

8010645b <vector180>:
.globl vector180
vector180:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $180
8010645d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106462:	e9 57 f4 ff ff       	jmp    801058be <alltraps>

80106467 <vector181>:
.globl vector181
vector181:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $181
80106469:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010646e:	e9 4b f4 ff ff       	jmp    801058be <alltraps>

80106473 <vector182>:
.globl vector182
vector182:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $182
80106475:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010647a:	e9 3f f4 ff ff       	jmp    801058be <alltraps>

8010647f <vector183>:
.globl vector183
vector183:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $183
80106481:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106486:	e9 33 f4 ff ff       	jmp    801058be <alltraps>

8010648b <vector184>:
.globl vector184
vector184:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $184
8010648d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106492:	e9 27 f4 ff ff       	jmp    801058be <alltraps>

80106497 <vector185>:
.globl vector185
vector185:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $185
80106499:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010649e:	e9 1b f4 ff ff       	jmp    801058be <alltraps>

801064a3 <vector186>:
.globl vector186
vector186:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $186
801064a5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064aa:	e9 0f f4 ff ff       	jmp    801058be <alltraps>

801064af <vector187>:
.globl vector187
vector187:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $187
801064b1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064b6:	e9 03 f4 ff ff       	jmp    801058be <alltraps>

801064bb <vector188>:
.globl vector188
vector188:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $188
801064bd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064c2:	e9 f7 f3 ff ff       	jmp    801058be <alltraps>

801064c7 <vector189>:
.globl vector189
vector189:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $189
801064c9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064ce:	e9 eb f3 ff ff       	jmp    801058be <alltraps>

801064d3 <vector190>:
.globl vector190
vector190:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $190
801064d5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064da:	e9 df f3 ff ff       	jmp    801058be <alltraps>

801064df <vector191>:
.globl vector191
vector191:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $191
801064e1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064e6:	e9 d3 f3 ff ff       	jmp    801058be <alltraps>

801064eb <vector192>:
.globl vector192
vector192:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $192
801064ed:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064f2:	e9 c7 f3 ff ff       	jmp    801058be <alltraps>

801064f7 <vector193>:
.globl vector193
vector193:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $193
801064f9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064fe:	e9 bb f3 ff ff       	jmp    801058be <alltraps>

80106503 <vector194>:
.globl vector194
vector194:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $194
80106505:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010650a:	e9 af f3 ff ff       	jmp    801058be <alltraps>

8010650f <vector195>:
.globl vector195
vector195:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $195
80106511:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106516:	e9 a3 f3 ff ff       	jmp    801058be <alltraps>

8010651b <vector196>:
.globl vector196
vector196:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $196
8010651d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106522:	e9 97 f3 ff ff       	jmp    801058be <alltraps>

80106527 <vector197>:
.globl vector197
vector197:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $197
80106529:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010652e:	e9 8b f3 ff ff       	jmp    801058be <alltraps>

80106533 <vector198>:
.globl vector198
vector198:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $198
80106535:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010653a:	e9 7f f3 ff ff       	jmp    801058be <alltraps>

8010653f <vector199>:
.globl vector199
vector199:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $199
80106541:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106546:	e9 73 f3 ff ff       	jmp    801058be <alltraps>

8010654b <vector200>:
.globl vector200
vector200:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $200
8010654d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106552:	e9 67 f3 ff ff       	jmp    801058be <alltraps>

80106557 <vector201>:
.globl vector201
vector201:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $201
80106559:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010655e:	e9 5b f3 ff ff       	jmp    801058be <alltraps>

80106563 <vector202>:
.globl vector202
vector202:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $202
80106565:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010656a:	e9 4f f3 ff ff       	jmp    801058be <alltraps>

8010656f <vector203>:
.globl vector203
vector203:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $203
80106571:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106576:	e9 43 f3 ff ff       	jmp    801058be <alltraps>

8010657b <vector204>:
.globl vector204
vector204:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $204
8010657d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106582:	e9 37 f3 ff ff       	jmp    801058be <alltraps>

80106587 <vector205>:
.globl vector205
vector205:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $205
80106589:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010658e:	e9 2b f3 ff ff       	jmp    801058be <alltraps>

80106593 <vector206>:
.globl vector206
vector206:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $206
80106595:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010659a:	e9 1f f3 ff ff       	jmp    801058be <alltraps>

8010659f <vector207>:
.globl vector207
vector207:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $207
801065a1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065a6:	e9 13 f3 ff ff       	jmp    801058be <alltraps>

801065ab <vector208>:
.globl vector208
vector208:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $208
801065ad:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065b2:	e9 07 f3 ff ff       	jmp    801058be <alltraps>

801065b7 <vector209>:
.globl vector209
vector209:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $209
801065b9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065be:	e9 fb f2 ff ff       	jmp    801058be <alltraps>

801065c3 <vector210>:
.globl vector210
vector210:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $210
801065c5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065ca:	e9 ef f2 ff ff       	jmp    801058be <alltraps>

801065cf <vector211>:
.globl vector211
vector211:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $211
801065d1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065d6:	e9 e3 f2 ff ff       	jmp    801058be <alltraps>

801065db <vector212>:
.globl vector212
vector212:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $212
801065dd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065e2:	e9 d7 f2 ff ff       	jmp    801058be <alltraps>

801065e7 <vector213>:
.globl vector213
vector213:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $213
801065e9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065ee:	e9 cb f2 ff ff       	jmp    801058be <alltraps>

801065f3 <vector214>:
.globl vector214
vector214:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $214
801065f5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065fa:	e9 bf f2 ff ff       	jmp    801058be <alltraps>

801065ff <vector215>:
.globl vector215
vector215:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $215
80106601:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106606:	e9 b3 f2 ff ff       	jmp    801058be <alltraps>

8010660b <vector216>:
.globl vector216
vector216:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $216
8010660d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106612:	e9 a7 f2 ff ff       	jmp    801058be <alltraps>

80106617 <vector217>:
.globl vector217
vector217:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $217
80106619:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010661e:	e9 9b f2 ff ff       	jmp    801058be <alltraps>

80106623 <vector218>:
.globl vector218
vector218:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $218
80106625:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010662a:	e9 8f f2 ff ff       	jmp    801058be <alltraps>

8010662f <vector219>:
.globl vector219
vector219:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $219
80106631:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106636:	e9 83 f2 ff ff       	jmp    801058be <alltraps>

8010663b <vector220>:
.globl vector220
vector220:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $220
8010663d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106642:	e9 77 f2 ff ff       	jmp    801058be <alltraps>

80106647 <vector221>:
.globl vector221
vector221:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $221
80106649:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010664e:	e9 6b f2 ff ff       	jmp    801058be <alltraps>

80106653 <vector222>:
.globl vector222
vector222:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $222
80106655:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010665a:	e9 5f f2 ff ff       	jmp    801058be <alltraps>

8010665f <vector223>:
.globl vector223
vector223:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $223
80106661:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106666:	e9 53 f2 ff ff       	jmp    801058be <alltraps>

8010666b <vector224>:
.globl vector224
vector224:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $224
8010666d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106672:	e9 47 f2 ff ff       	jmp    801058be <alltraps>

80106677 <vector225>:
.globl vector225
vector225:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $225
80106679:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010667e:	e9 3b f2 ff ff       	jmp    801058be <alltraps>

80106683 <vector226>:
.globl vector226
vector226:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $226
80106685:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010668a:	e9 2f f2 ff ff       	jmp    801058be <alltraps>

8010668f <vector227>:
.globl vector227
vector227:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $227
80106691:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106696:	e9 23 f2 ff ff       	jmp    801058be <alltraps>

8010669b <vector228>:
.globl vector228
vector228:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $228
8010669d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066a2:	e9 17 f2 ff ff       	jmp    801058be <alltraps>

801066a7 <vector229>:
.globl vector229
vector229:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $229
801066a9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066ae:	e9 0b f2 ff ff       	jmp    801058be <alltraps>

801066b3 <vector230>:
.globl vector230
vector230:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $230
801066b5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066ba:	e9 ff f1 ff ff       	jmp    801058be <alltraps>

801066bf <vector231>:
.globl vector231
vector231:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $231
801066c1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066c6:	e9 f3 f1 ff ff       	jmp    801058be <alltraps>

801066cb <vector232>:
.globl vector232
vector232:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $232
801066cd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066d2:	e9 e7 f1 ff ff       	jmp    801058be <alltraps>

801066d7 <vector233>:
.globl vector233
vector233:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $233
801066d9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066de:	e9 db f1 ff ff       	jmp    801058be <alltraps>

801066e3 <vector234>:
.globl vector234
vector234:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $234
801066e5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066ea:	e9 cf f1 ff ff       	jmp    801058be <alltraps>

801066ef <vector235>:
.globl vector235
vector235:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $235
801066f1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066f6:	e9 c3 f1 ff ff       	jmp    801058be <alltraps>

801066fb <vector236>:
.globl vector236
vector236:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $236
801066fd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106702:	e9 b7 f1 ff ff       	jmp    801058be <alltraps>

80106707 <vector237>:
.globl vector237
vector237:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $237
80106709:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010670e:	e9 ab f1 ff ff       	jmp    801058be <alltraps>

80106713 <vector238>:
.globl vector238
vector238:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $238
80106715:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010671a:	e9 9f f1 ff ff       	jmp    801058be <alltraps>

8010671f <vector239>:
.globl vector239
vector239:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $239
80106721:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106726:	e9 93 f1 ff ff       	jmp    801058be <alltraps>

8010672b <vector240>:
.globl vector240
vector240:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $240
8010672d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106732:	e9 87 f1 ff ff       	jmp    801058be <alltraps>

80106737 <vector241>:
.globl vector241
vector241:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $241
80106739:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010673e:	e9 7b f1 ff ff       	jmp    801058be <alltraps>

80106743 <vector242>:
.globl vector242
vector242:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $242
80106745:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010674a:	e9 6f f1 ff ff       	jmp    801058be <alltraps>

8010674f <vector243>:
.globl vector243
vector243:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $243
80106751:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106756:	e9 63 f1 ff ff       	jmp    801058be <alltraps>

8010675b <vector244>:
.globl vector244
vector244:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $244
8010675d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106762:	e9 57 f1 ff ff       	jmp    801058be <alltraps>

80106767 <vector245>:
.globl vector245
vector245:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $245
80106769:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010676e:	e9 4b f1 ff ff       	jmp    801058be <alltraps>

80106773 <vector246>:
.globl vector246
vector246:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $246
80106775:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010677a:	e9 3f f1 ff ff       	jmp    801058be <alltraps>

8010677f <vector247>:
.globl vector247
vector247:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $247
80106781:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106786:	e9 33 f1 ff ff       	jmp    801058be <alltraps>

8010678b <vector248>:
.globl vector248
vector248:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $248
8010678d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106792:	e9 27 f1 ff ff       	jmp    801058be <alltraps>

80106797 <vector249>:
.globl vector249
vector249:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $249
80106799:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010679e:	e9 1b f1 ff ff       	jmp    801058be <alltraps>

801067a3 <vector250>:
.globl vector250
vector250:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $250
801067a5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067aa:	e9 0f f1 ff ff       	jmp    801058be <alltraps>

801067af <vector251>:
.globl vector251
vector251:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $251
801067b1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067b6:	e9 03 f1 ff ff       	jmp    801058be <alltraps>

801067bb <vector252>:
.globl vector252
vector252:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $252
801067bd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067c2:	e9 f7 f0 ff ff       	jmp    801058be <alltraps>

801067c7 <vector253>:
.globl vector253
vector253:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $253
801067c9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067ce:	e9 eb f0 ff ff       	jmp    801058be <alltraps>

801067d3 <vector254>:
.globl vector254
vector254:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $254
801067d5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067da:	e9 df f0 ff ff       	jmp    801058be <alltraps>

801067df <vector255>:
.globl vector255
vector255:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $255
801067e1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067e6:	e9 d3 f0 ff ff       	jmp    801058be <alltraps>
801067eb:	66 90                	xchg   %ax,%ax
801067ed:	66 90                	xchg   %ax,%ax
801067ef:	90                   	nop

801067f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801067f7:	c1 ea 16             	shr    $0x16,%edx
{
801067fa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801067fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801067fe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106801:	8b 1f                	mov    (%edi),%ebx
80106803:	f6 c3 01             	test   $0x1,%bl
80106806:	74 28                	je     80106830 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106808:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010680e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106814:	89 f0                	mov    %esi,%eax
}
80106816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106819:	c1 e8 0a             	shr    $0xa,%eax
8010681c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106821:	01 d8                	add    %ebx,%eax
}
80106823:	5b                   	pop    %ebx
80106824:	5e                   	pop    %esi
80106825:	5f                   	pop    %edi
80106826:	5d                   	pop    %ebp
80106827:	c3                   	ret    
80106828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106830:	85 c9                	test   %ecx,%ecx
80106832:	74 2c                	je     80106860 <walkpgdir+0x70>
80106834:	e8 27 be ff ff       	call   80102660 <kalloc>
80106839:	89 c3                	mov    %eax,%ebx
8010683b:	85 c0                	test   %eax,%eax
8010683d:	74 21                	je     80106860 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010683f:	83 ec 04             	sub    $0x4,%esp
80106842:	68 00 10 00 00       	push   $0x1000
80106847:	6a 00                	push   $0x0
80106849:	50                   	push   %eax
8010684a:	e8 71 de ff ff       	call   801046c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010684f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106855:	83 c4 10             	add    $0x10,%esp
80106858:	83 c8 07             	or     $0x7,%eax
8010685b:	89 07                	mov    %eax,(%edi)
8010685d:	eb b5                	jmp    80106814 <walkpgdir+0x24>
8010685f:	90                   	nop
}
80106860:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106863:	31 c0                	xor    %eax,%eax
}
80106865:	5b                   	pop    %ebx
80106866:	5e                   	pop    %esi
80106867:	5f                   	pop    %edi
80106868:	5d                   	pop    %ebp
80106869:	c3                   	ret    
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106876:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010687a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010687b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106880:	89 d6                	mov    %edx,%esi
{
80106882:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106883:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106889:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010688c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010688f:	8b 45 08             	mov    0x8(%ebp),%eax
80106892:	29 f0                	sub    %esi,%eax
80106894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106897:	eb 1f                	jmp    801068b8 <mappages+0x48>
80106899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801068a0:	f6 00 01             	testb  $0x1,(%eax)
801068a3:	75 45                	jne    801068ea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801068a5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801068a8:	83 cb 01             	or     $0x1,%ebx
801068ab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801068ad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801068b0:	74 2e                	je     801068e0 <mappages+0x70>
      break;
    a += PGSIZE;
801068b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801068b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068bb:	b9 01 00 00 00       	mov    $0x1,%ecx
801068c0:	89 f2                	mov    %esi,%edx
801068c2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801068c5:	89 f8                	mov    %edi,%eax
801068c7:	e8 24 ff ff ff       	call   801067f0 <walkpgdir>
801068cc:	85 c0                	test   %eax,%eax
801068ce:	75 d0                	jne    801068a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801068d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801068d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068d8:	5b                   	pop    %ebx
801068d9:	5e                   	pop    %esi
801068da:	5f                   	pop    %edi
801068db:	5d                   	pop    %ebp
801068dc:	c3                   	ret    
801068dd:	8d 76 00             	lea    0x0(%esi),%esi
801068e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801068e3:	31 c0                	xor    %eax,%eax
}
801068e5:	5b                   	pop    %ebx
801068e6:	5e                   	pop    %esi
801068e7:	5f                   	pop    %edi
801068e8:	5d                   	pop    %ebp
801068e9:	c3                   	ret    
      panic("remap");
801068ea:	83 ec 0c             	sub    $0xc,%esp
801068ed:	68 e8 79 10 80       	push   $0x801079e8
801068f2:	e8 99 9a ff ff       	call   80100390 <panic>
801068f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068fe:	66 90                	xchg   %ax,%ax

80106900 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	89 c6                	mov    %eax,%esi
80106907:	53                   	push   %ebx
80106908:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010690a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106910:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010691c:	39 da                	cmp    %ebx,%edx
8010691e:	73 5b                	jae    8010697b <deallocuvm.part.0+0x7b>
80106920:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106923:	89 d7                	mov    %edx,%edi
80106925:	eb 14                	jmp    8010693b <deallocuvm.part.0+0x3b>
80106927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692e:	66 90                	xchg   %ax,%ax
80106930:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106936:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106939:	76 40                	jbe    8010697b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010693b:	31 c9                	xor    %ecx,%ecx
8010693d:	89 fa                	mov    %edi,%edx
8010693f:	89 f0                	mov    %esi,%eax
80106941:	e8 aa fe ff ff       	call   801067f0 <walkpgdir>
80106946:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106948:	85 c0                	test   %eax,%eax
8010694a:	74 44                	je     80106990 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010694c:	8b 00                	mov    (%eax),%eax
8010694e:	a8 01                	test   $0x1,%al
80106950:	74 de                	je     80106930 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106952:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106957:	74 47                	je     801069a0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106959:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010695c:	05 00 00 00 80       	add    $0x80000000,%eax
80106961:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106967:	50                   	push   %eax
80106968:	e8 03 bb ff ff       	call   80102470 <kfree>
      *pte = 0;
8010696d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106973:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106976:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106979:	77 c0                	ja     8010693b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010697b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010697e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106981:	5b                   	pop    %ebx
80106982:	5e                   	pop    %esi
80106983:	5f                   	pop    %edi
80106984:	5d                   	pop    %ebp
80106985:	c3                   	ret    
80106986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010698d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106990:	89 fa                	mov    %edi,%edx
80106992:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106998:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010699e:	eb 96                	jmp    80106936 <deallocuvm.part.0+0x36>
        panic("kfree");
801069a0:	83 ec 0c             	sub    $0xc,%esp
801069a3:	68 a6 73 10 80       	push   $0x801073a6
801069a8:	e8 e3 99 ff ff       	call   80100390 <panic>
801069ad:	8d 76 00             	lea    0x0(%esi),%esi

801069b0 <seginit>:
{
801069b0:	f3 0f 1e fb          	endbr32 
801069b4:	55                   	push   %ebp
801069b5:	89 e5                	mov    %esp,%ebp
801069b7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069ba:	e8 d1 cf ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
801069bf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069c4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069ca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069ce:	c7 80 98 d1 14 80 ff 	movl   $0xffff,-0x7feb2e68(%eax)
801069d5:	ff 00 00 
801069d8:	c7 80 9c d1 14 80 00 	movl   $0xcf9a00,-0x7feb2e64(%eax)
801069df:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069e2:	c7 80 a0 d1 14 80 ff 	movl   $0xffff,-0x7feb2e60(%eax)
801069e9:	ff 00 00 
801069ec:	c7 80 a4 d1 14 80 00 	movl   $0xcf9200,-0x7feb2e5c(%eax)
801069f3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069f6:	c7 80 a8 d1 14 80 ff 	movl   $0xffff,-0x7feb2e58(%eax)
801069fd:	ff 00 00 
80106a00:	c7 80 ac d1 14 80 00 	movl   $0xcffa00,-0x7feb2e54(%eax)
80106a07:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a0a:	c7 80 b0 d1 14 80 ff 	movl   $0xffff,-0x7feb2e50(%eax)
80106a11:	ff 00 00 
80106a14:	c7 80 b4 d1 14 80 00 	movl   $0xcff200,-0x7feb2e4c(%eax)
80106a1b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a1e:	05 90 d1 14 80       	add    $0x8014d190,%eax
  pd[1] = (uint)p;
80106a23:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a27:	c1 e8 10             	shr    $0x10,%eax
80106a2a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a2e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a31:	0f 01 10             	lgdtl  (%eax)
}
80106a34:	c9                   	leave  
80106a35:	c3                   	ret    
80106a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a3d:	8d 76 00             	lea    0x0(%esi),%esi

80106a40 <switchkvm>:
{
80106a40:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a44:	a1 44 fe 14 80       	mov    0x8014fe44,%eax
80106a49:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a4e:	0f 22 d8             	mov    %eax,%cr3
}
80106a51:	c3                   	ret    
80106a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a60 <switchuvm>:
{
80106a60:	f3 0f 1e fb          	endbr32 
80106a64:	55                   	push   %ebp
80106a65:	89 e5                	mov    %esp,%ebp
80106a67:	57                   	push   %edi
80106a68:	56                   	push   %esi
80106a69:	53                   	push   %ebx
80106a6a:	83 ec 1c             	sub    $0x1c,%esp
80106a6d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a70:	85 f6                	test   %esi,%esi
80106a72:	0f 84 cb 00 00 00    	je     80106b43 <switchuvm+0xe3>
  if(p->kstack == 0)
80106a78:	8b 46 08             	mov    0x8(%esi),%eax
80106a7b:	85 c0                	test   %eax,%eax
80106a7d:	0f 84 da 00 00 00    	je     80106b5d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106a83:	8b 46 04             	mov    0x4(%esi),%eax
80106a86:	85 c0                	test   %eax,%eax
80106a88:	0f 84 c2 00 00 00    	je     80106b50 <switchuvm+0xf0>
  pushcli();
80106a8e:	e8 1d da ff ff       	call   801044b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a93:	e8 88 ce ff ff       	call   80103920 <mycpu>
80106a98:	89 c3                	mov    %eax,%ebx
80106a9a:	e8 81 ce ff ff       	call   80103920 <mycpu>
80106a9f:	89 c7                	mov    %eax,%edi
80106aa1:	e8 7a ce ff ff       	call   80103920 <mycpu>
80106aa6:	83 c7 08             	add    $0x8,%edi
80106aa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aac:	e8 6f ce ff ff       	call   80103920 <mycpu>
80106ab1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ab4:	ba 67 00 00 00       	mov    $0x67,%edx
80106ab9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ac0:	83 c0 08             	add    $0x8,%eax
80106ac3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106aca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106acf:	83 c1 08             	add    $0x8,%ecx
80106ad2:	c1 e8 18             	shr    $0x18,%eax
80106ad5:	c1 e9 10             	shr    $0x10,%ecx
80106ad8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ade:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ae4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ae9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106af0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106af5:	e8 26 ce ff ff       	call   80103920 <mycpu>
80106afa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b01:	e8 1a ce ff ff       	call   80103920 <mycpu>
80106b06:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b0a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b13:	e8 08 ce ff ff       	call   80103920 <mycpu>
80106b18:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b1b:	e8 00 ce ff ff       	call   80103920 <mycpu>
80106b20:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b24:	b8 28 00 00 00       	mov    $0x28,%eax
80106b29:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b2c:	8b 46 04             	mov    0x4(%esi),%eax
80106b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b34:	0f 22 d8             	mov    %eax,%cr3
}
80106b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b3a:	5b                   	pop    %ebx
80106b3b:	5e                   	pop    %esi
80106b3c:	5f                   	pop    %edi
80106b3d:	5d                   	pop    %ebp
  popcli();
80106b3e:	e9 bd d9 ff ff       	jmp    80104500 <popcli>
    panic("switchuvm: no process");
80106b43:	83 ec 0c             	sub    $0xc,%esp
80106b46:	68 ee 79 10 80       	push   $0x801079ee
80106b4b:	e8 40 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106b50:	83 ec 0c             	sub    $0xc,%esp
80106b53:	68 19 7a 10 80       	push   $0x80107a19
80106b58:	e8 33 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106b5d:	83 ec 0c             	sub    $0xc,%esp
80106b60:	68 04 7a 10 80       	push   $0x80107a04
80106b65:	e8 26 98 ff ff       	call   80100390 <panic>
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b70 <inituvm>:
{
80106b70:	f3 0f 1e fb          	endbr32 
80106b74:	55                   	push   %ebp
80106b75:	89 e5                	mov    %esp,%ebp
80106b77:	57                   	push   %edi
80106b78:	56                   	push   %esi
80106b79:	53                   	push   %ebx
80106b7a:	83 ec 1c             	sub    $0x1c,%esp
80106b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b80:	8b 75 10             	mov    0x10(%ebp),%esi
80106b83:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b89:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b8f:	77 4b                	ja     80106bdc <inituvm+0x6c>
  mem = kalloc();
80106b91:	e8 ca ba ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80106b96:	83 ec 04             	sub    $0x4,%esp
80106b99:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106b9e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ba0:	6a 00                	push   $0x0
80106ba2:	50                   	push   %eax
80106ba3:	e8 18 db ff ff       	call   801046c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ba8:	58                   	pop    %eax
80106ba9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106baf:	5a                   	pop    %edx
80106bb0:	6a 06                	push   $0x6
80106bb2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bb7:	31 d2                	xor    %edx,%edx
80106bb9:	50                   	push   %eax
80106bba:	89 f8                	mov    %edi,%eax
80106bbc:	e8 af fc ff ff       	call   80106870 <mappages>
  memmove(mem, init, sz);
80106bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc4:	89 75 10             	mov    %esi,0x10(%ebp)
80106bc7:	83 c4 10             	add    $0x10,%esp
80106bca:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106bcd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bd3:	5b                   	pop    %ebx
80106bd4:	5e                   	pop    %esi
80106bd5:	5f                   	pop    %edi
80106bd6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106bd7:	e9 84 db ff ff       	jmp    80104760 <memmove>
    panic("inituvm: more than a page");
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	68 2d 7a 10 80       	push   $0x80107a2d
80106be4:	e8 a7 97 ff ff       	call   80100390 <panic>
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <loaduvm>:
{
80106bf0:	f3 0f 1e fb          	endbr32 
80106bf4:	55                   	push   %ebp
80106bf5:	89 e5                	mov    %esp,%ebp
80106bf7:	57                   	push   %edi
80106bf8:	56                   	push   %esi
80106bf9:	53                   	push   %ebx
80106bfa:	83 ec 1c             	sub    $0x1c,%esp
80106bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c00:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c08:	0f 85 99 00 00 00    	jne    80106ca7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106c0e:	01 f0                	add    %esi,%eax
80106c10:	89 f3                	mov    %esi,%ebx
80106c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c15:	8b 45 14             	mov    0x14(%ebp),%eax
80106c18:	01 f0                	add    %esi,%eax
80106c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c1d:	85 f6                	test   %esi,%esi
80106c1f:	75 15                	jne    80106c36 <loaduvm+0x46>
80106c21:	eb 6d                	jmp    80106c90 <loaduvm+0xa0>
80106c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c27:	90                   	nop
80106c28:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106c2e:	89 f0                	mov    %esi,%eax
80106c30:	29 d8                	sub    %ebx,%eax
80106c32:	39 c6                	cmp    %eax,%esi
80106c34:	76 5a                	jbe    80106c90 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c39:	8b 45 08             	mov    0x8(%ebp),%eax
80106c3c:	31 c9                	xor    %ecx,%ecx
80106c3e:	29 da                	sub    %ebx,%edx
80106c40:	e8 ab fb ff ff       	call   801067f0 <walkpgdir>
80106c45:	85 c0                	test   %eax,%eax
80106c47:	74 51                	je     80106c9a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106c49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106c5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c61:	29 d9                	sub    %ebx,%ecx
80106c63:	05 00 00 00 80       	add    $0x80000000,%eax
80106c68:	57                   	push   %edi
80106c69:	51                   	push   %ecx
80106c6a:	50                   	push   %eax
80106c6b:	ff 75 10             	pushl  0x10(%ebp)
80106c6e:	e8 ed ad ff ff       	call   80101a60 <readi>
80106c73:	83 c4 10             	add    $0x10,%esp
80106c76:	39 f8                	cmp    %edi,%eax
80106c78:	74 ae                	je     80106c28 <loaduvm+0x38>
}
80106c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c82:	5b                   	pop    %ebx
80106c83:	5e                   	pop    %esi
80106c84:	5f                   	pop    %edi
80106c85:	5d                   	pop    %ebp
80106c86:	c3                   	ret    
80106c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8e:	66 90                	xchg   %ax,%ax
80106c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c93:	31 c0                	xor    %eax,%eax
}
80106c95:	5b                   	pop    %ebx
80106c96:	5e                   	pop    %esi
80106c97:	5f                   	pop    %edi
80106c98:	5d                   	pop    %ebp
80106c99:	c3                   	ret    
      panic("loaduvm: address should exist");
80106c9a:	83 ec 0c             	sub    $0xc,%esp
80106c9d:	68 47 7a 10 80       	push   $0x80107a47
80106ca2:	e8 e9 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ca7:	83 ec 0c             	sub    $0xc,%esp
80106caa:	68 e8 7a 10 80       	push   $0x80107ae8
80106caf:	e8 dc 96 ff ff       	call   80100390 <panic>
80106cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cbf:	90                   	nop

80106cc0 <allocuvm>:
{
80106cc0:	f3 0f 1e fb          	endbr32 
80106cc4:	55                   	push   %ebp
80106cc5:	89 e5                	mov    %esp,%ebp
80106cc7:	57                   	push   %edi
80106cc8:	56                   	push   %esi
80106cc9:	53                   	push   %ebx
80106cca:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ccd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106cd0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cd6:	85 c0                	test   %eax,%eax
80106cd8:	0f 88 b2 00 00 00    	js     80106d90 <allocuvm+0xd0>
  if(newsz < oldsz)
80106cde:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ce4:	0f 82 96 00 00 00    	jb     80106d80 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106cea:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106cf0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106cf6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106cf9:	77 40                	ja     80106d3b <allocuvm+0x7b>
80106cfb:	e9 83 00 00 00       	jmp    80106d83 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106d00:	83 ec 04             	sub    $0x4,%esp
80106d03:	68 00 10 00 00       	push   $0x1000
80106d08:	6a 00                	push   $0x0
80106d0a:	50                   	push   %eax
80106d0b:	e8 b0 d9 ff ff       	call   801046c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d10:	58                   	pop    %eax
80106d11:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d17:	5a                   	pop    %edx
80106d18:	6a 06                	push   $0x6
80106d1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d1f:	89 f2                	mov    %esi,%edx
80106d21:	50                   	push   %eax
80106d22:	89 f8                	mov    %edi,%eax
80106d24:	e8 47 fb ff ff       	call   80106870 <mappages>
80106d29:	83 c4 10             	add    $0x10,%esp
80106d2c:	85 c0                	test   %eax,%eax
80106d2e:	78 78                	js     80106da8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106d30:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d36:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d39:	76 48                	jbe    80106d83 <allocuvm+0xc3>
    mem = kalloc();
80106d3b:	e8 20 b9 ff ff       	call   80102660 <kalloc>
80106d40:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d42:	85 c0                	test   %eax,%eax
80106d44:	75 ba                	jne    80106d00 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	68 65 7a 10 80       	push   $0x80107a65
80106d4e:	e8 5d 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d56:	83 c4 10             	add    $0x10,%esp
80106d59:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d5c:	74 32                	je     80106d90 <allocuvm+0xd0>
80106d5e:	8b 55 10             	mov    0x10(%ebp),%edx
80106d61:	89 c1                	mov    %eax,%ecx
80106d63:	89 f8                	mov    %edi,%eax
80106d65:	e8 96 fb ff ff       	call   80106900 <deallocuvm.part.0>
      return 0;
80106d6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d77:	5b                   	pop    %ebx
80106d78:	5e                   	pop    %esi
80106d79:	5f                   	pop    %edi
80106d7a:	5d                   	pop    %ebp
80106d7b:	c3                   	ret    
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d89:	5b                   	pop    %ebx
80106d8a:	5e                   	pop    %esi
80106d8b:	5f                   	pop    %edi
80106d8c:	5d                   	pop    %ebp
80106d8d:	c3                   	ret    
80106d8e:	66 90                	xchg   %ax,%ax
    return 0;
80106d90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d9d:	5b                   	pop    %ebx
80106d9e:	5e                   	pop    %esi
80106d9f:	5f                   	pop    %edi
80106da0:	5d                   	pop    %ebp
80106da1:	c3                   	ret    
80106da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106da8:	83 ec 0c             	sub    $0xc,%esp
80106dab:	68 7d 7a 10 80       	push   $0x80107a7d
80106db0:	e8 fb 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106db8:	83 c4 10             	add    $0x10,%esp
80106dbb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dbe:	74 0c                	je     80106dcc <allocuvm+0x10c>
80106dc0:	8b 55 10             	mov    0x10(%ebp),%edx
80106dc3:	89 c1                	mov    %eax,%ecx
80106dc5:	89 f8                	mov    %edi,%eax
80106dc7:	e8 34 fb ff ff       	call   80106900 <deallocuvm.part.0>
      kfree(mem);
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	53                   	push   %ebx
80106dd0:	e8 9b b6 ff ff       	call   80102470 <kfree>
      return 0;
80106dd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106ddc:	83 c4 10             	add    $0x10,%esp
}
80106ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106df0 <deallocuvm>:
{
80106df0:	f3 0f 1e fb          	endbr32 
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e00:	39 d1                	cmp    %edx,%ecx
80106e02:	73 0c                	jae    80106e10 <deallocuvm+0x20>
}
80106e04:	5d                   	pop    %ebp
80106e05:	e9 f6 fa ff ff       	jmp    80106900 <deallocuvm.part.0>
80106e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e10:	89 d0                	mov    %edx,%eax
80106e12:	5d                   	pop    %ebp
80106e13:	c3                   	ret    
80106e14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e1f:	90                   	nop

80106e20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e20:	f3 0f 1e fb          	endbr32 
80106e24:	55                   	push   %ebp
80106e25:	89 e5                	mov    %esp,%ebp
80106e27:	57                   	push   %edi
80106e28:	56                   	push   %esi
80106e29:	53                   	push   %ebx
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e30:	85 f6                	test   %esi,%esi
80106e32:	74 55                	je     80106e89 <freevm+0x69>
  if(newsz >= oldsz)
80106e34:	31 c9                	xor    %ecx,%ecx
80106e36:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e3b:	89 f0                	mov    %esi,%eax
80106e3d:	89 f3                	mov    %esi,%ebx
80106e3f:	e8 bc fa ff ff       	call   80106900 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e44:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e4a:	eb 0b                	jmp    80106e57 <freevm+0x37>
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e50:	83 c3 04             	add    $0x4,%ebx
80106e53:	39 df                	cmp    %ebx,%edi
80106e55:	74 23                	je     80106e7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e57:	8b 03                	mov    (%ebx),%eax
80106e59:	a8 01                	test   $0x1,%al
80106e5b:	74 f3                	je     80106e50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e62:	83 ec 0c             	sub    $0xc,%esp
80106e65:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e68:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e6d:	50                   	push   %eax
80106e6e:	e8 fd b5 ff ff       	call   80102470 <kfree>
80106e73:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e76:	39 df                	cmp    %ebx,%edi
80106e78:	75 dd                	jne    80106e57 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e80:	5b                   	pop    %ebx
80106e81:	5e                   	pop    %esi
80106e82:	5f                   	pop    %edi
80106e83:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e84:	e9 e7 b5 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80106e89:	83 ec 0c             	sub    $0xc,%esp
80106e8c:	68 99 7a 10 80       	push   $0x80107a99
80106e91:	e8 fa 94 ff ff       	call   80100390 <panic>
80106e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ea0 <setupkvm>:
{
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
80106ea5:	89 e5                	mov    %esp,%ebp
80106ea7:	56                   	push   %esi
80106ea8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ea9:	e8 b2 b7 ff ff       	call   80102660 <kalloc>
80106eae:	89 c6                	mov    %eax,%esi
80106eb0:	85 c0                	test   %eax,%eax
80106eb2:	74 42                	je     80106ef6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106eb4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106eb7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ebc:	68 00 10 00 00       	push   $0x1000
80106ec1:	6a 00                	push   $0x0
80106ec3:	50                   	push   %eax
80106ec4:	e8 f7 d7 ff ff       	call   801046c0 <memset>
80106ec9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ecc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ecf:	83 ec 08             	sub    $0x8,%esp
80106ed2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ed5:	ff 73 0c             	pushl  0xc(%ebx)
80106ed8:	8b 13                	mov    (%ebx),%edx
80106eda:	50                   	push   %eax
80106edb:	29 c1                	sub    %eax,%ecx
80106edd:	89 f0                	mov    %esi,%eax
80106edf:	e8 8c f9 ff ff       	call   80106870 <mappages>
80106ee4:	83 c4 10             	add    $0x10,%esp
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	78 15                	js     80106f00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106eeb:	83 c3 10             	add    $0x10,%ebx
80106eee:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ef4:	75 d6                	jne    80106ecc <setupkvm+0x2c>
}
80106ef6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ef9:	89 f0                	mov    %esi,%eax
80106efb:	5b                   	pop    %ebx
80106efc:	5e                   	pop    %esi
80106efd:	5d                   	pop    %ebp
80106efe:	c3                   	ret    
80106eff:	90                   	nop
      freevm(pgdir);
80106f00:	83 ec 0c             	sub    $0xc,%esp
80106f03:	56                   	push   %esi
      return 0;
80106f04:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f06:	e8 15 ff ff ff       	call   80106e20 <freevm>
      return 0;
80106f0b:	83 c4 10             	add    $0x10,%esp
}
80106f0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f11:	89 f0                	mov    %esi,%eax
80106f13:	5b                   	pop    %ebx
80106f14:	5e                   	pop    %esi
80106f15:	5d                   	pop    %ebp
80106f16:	c3                   	ret    
80106f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1e:	66 90                	xchg   %ax,%ax

80106f20 <kvmalloc>:
{
80106f20:	f3 0f 1e fb          	endbr32 
80106f24:	55                   	push   %ebp
80106f25:	89 e5                	mov    %esp,%ebp
80106f27:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f2a:	e8 71 ff ff ff       	call   80106ea0 <setupkvm>
80106f2f:	a3 44 fe 14 80       	mov    %eax,0x8014fe44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f34:	05 00 00 00 80       	add    $0x80000000,%eax
80106f39:	0f 22 d8             	mov    %eax,%cr3
}
80106f3c:	c9                   	leave  
80106f3d:	c3                   	ret    
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f40:	f3 0f 1e fb          	endbr32 
80106f44:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f45:	31 c9                	xor    %ecx,%ecx
{
80106f47:	89 e5                	mov    %esp,%ebp
80106f49:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f52:	e8 99 f8 ff ff       	call   801067f0 <walkpgdir>
  if(pte == 0)
80106f57:	85 c0                	test   %eax,%eax
80106f59:	74 05                	je     80106f60 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f5b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f5e:	c9                   	leave  
80106f5f:	c3                   	ret    
    panic("clearpteu");
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	68 aa 7a 10 80       	push   $0x80107aaa
80106f68:	e8 23 94 ff ff       	call   80100390 <panic>
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi

80106f70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f70:	f3 0f 1e fb          	endbr32 
80106f74:	55                   	push   %ebp
80106f75:	89 e5                	mov    %esp,%ebp
80106f77:	57                   	push   %edi
80106f78:	56                   	push   %esi
80106f79:	53                   	push   %ebx
80106f7a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f7d:	e8 1e ff ff ff       	call   80106ea0 <setupkvm>
80106f82:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f85:	85 c0                	test   %eax,%eax
80106f87:	0f 84 9b 00 00 00    	je     80107028 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f90:	85 c9                	test   %ecx,%ecx
80106f92:	0f 84 90 00 00 00    	je     80107028 <copyuvm+0xb8>
80106f98:	31 f6                	xor    %esi,%esi
80106f9a:	eb 46                	jmp    80106fe2 <copyuvm+0x72>
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fa9:	68 00 10 00 00       	push   $0x1000
80106fae:	57                   	push   %edi
80106faf:	50                   	push   %eax
80106fb0:	e8 ab d7 ff ff       	call   80104760 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106fb5:	58                   	pop    %eax
80106fb6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fbc:	5a                   	pop    %edx
80106fbd:	ff 75 e4             	pushl  -0x1c(%ebp)
80106fc0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fc5:	89 f2                	mov    %esi,%edx
80106fc7:	50                   	push   %eax
80106fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fcb:	e8 a0 f8 ff ff       	call   80106870 <mappages>
80106fd0:	83 c4 10             	add    $0x10,%esp
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	78 61                	js     80107038 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fd7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fdd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106fe0:	76 46                	jbe    80107028 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe5:	31 c9                	xor    %ecx,%ecx
80106fe7:	89 f2                	mov    %esi,%edx
80106fe9:	e8 02 f8 ff ff       	call   801067f0 <walkpgdir>
80106fee:	85 c0                	test   %eax,%eax
80106ff0:	74 61                	je     80107053 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106ff2:	8b 00                	mov    (%eax),%eax
80106ff4:	a8 01                	test   $0x1,%al
80106ff6:	74 4e                	je     80107046 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106ff8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106ffa:	25 ff 0f 00 00       	and    $0xfff,%eax
80106fff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107002:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107008:	e8 53 b6 ff ff       	call   80102660 <kalloc>
8010700d:	89 c3                	mov    %eax,%ebx
8010700f:	85 c0                	test   %eax,%eax
80107011:	75 8d                	jne    80106fa0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107013:	83 ec 0c             	sub    $0xc,%esp
80107016:	ff 75 e0             	pushl  -0x20(%ebp)
80107019:	e8 02 fe ff ff       	call   80106e20 <freevm>
  return 0;
8010701e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107025:	83 c4 10             	add    $0x10,%esp
}
80107028:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010702b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010702e:	5b                   	pop    %ebx
8010702f:	5e                   	pop    %esi
80107030:	5f                   	pop    %edi
80107031:	5d                   	pop    %ebp
80107032:	c3                   	ret    
80107033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107037:	90                   	nop
      kfree(mem);
80107038:	83 ec 0c             	sub    $0xc,%esp
8010703b:	53                   	push   %ebx
8010703c:	e8 2f b4 ff ff       	call   80102470 <kfree>
      goto bad;
80107041:	83 c4 10             	add    $0x10,%esp
80107044:	eb cd                	jmp    80107013 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	68 ce 7a 10 80       	push   $0x80107ace
8010704e:	e8 3d 93 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107053:	83 ec 0c             	sub    $0xc,%esp
80107056:	68 b4 7a 10 80       	push   $0x80107ab4
8010705b:	e8 30 93 ff ff       	call   80100390 <panic>

80107060 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107060:	f3 0f 1e fb          	endbr32 
80107064:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107065:	31 c9                	xor    %ecx,%ecx
{
80107067:	89 e5                	mov    %esp,%ebp
80107069:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010706c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010706f:	8b 45 08             	mov    0x8(%ebp),%eax
80107072:	e8 79 f7 ff ff       	call   801067f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107077:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107079:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010707a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010707c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107081:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107084:	05 00 00 00 80       	add    $0x80000000,%eax
80107089:	83 fa 05             	cmp    $0x5,%edx
8010708c:	ba 00 00 00 00       	mov    $0x0,%edx
80107091:	0f 45 c2             	cmovne %edx,%eax
}
80107094:	c3                   	ret    
80107095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	57                   	push   %edi
801070a8:	56                   	push   %esi
801070a9:	53                   	push   %ebx
801070aa:	83 ec 0c             	sub    $0xc,%esp
801070ad:	8b 75 14             	mov    0x14(%ebp),%esi
801070b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070b3:	85 f6                	test   %esi,%esi
801070b5:	75 3c                	jne    801070f3 <copyout+0x53>
801070b7:	eb 67                	jmp    80107120 <copyout+0x80>
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801070c3:	89 fb                	mov    %edi,%ebx
801070c5:	29 d3                	sub    %edx,%ebx
801070c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801070cd:	39 f3                	cmp    %esi,%ebx
801070cf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070d2:	29 fa                	sub    %edi,%edx
801070d4:	83 ec 04             	sub    $0x4,%esp
801070d7:	01 c2                	add    %eax,%edx
801070d9:	53                   	push   %ebx
801070da:	ff 75 10             	pushl  0x10(%ebp)
801070dd:	52                   	push   %edx
801070de:	e8 7d d6 ff ff       	call   80104760 <memmove>
    len -= n;
    buf += n;
801070e3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801070e6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	29 de                	sub    %ebx,%esi
801070f1:	74 2d                	je     80107120 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801070f3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801070f5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801070f8:	89 55 0c             	mov    %edx,0xc(%ebp)
801070fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107101:	57                   	push   %edi
80107102:	ff 75 08             	pushl  0x8(%ebp)
80107105:	e8 56 ff ff ff       	call   80107060 <uva2ka>
    if(pa0 == 0)
8010710a:	83 c4 10             	add    $0x10,%esp
8010710d:	85 c0                	test   %eax,%eax
8010710f:	75 af                	jne    801070c0 <copyout+0x20>
  }
  return 0;
}
80107111:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107119:	5b                   	pop    %ebx
8010711a:	5e                   	pop    %esi
8010711b:	5f                   	pop    %edi
8010711c:	5d                   	pop    %ebp
8010711d:	c3                   	ret    
8010711e:	66 90                	xchg   %ax,%ax
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107123:	31 c0                	xor    %eax,%eax
}
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
