package;

class AnimateThrower {
	public var index:Int;
	public var priority:Int;
	public var check:Void->Bool; // function pointer
	
	public function new( i:Int, ch:Void->Bool, p:Int ) {
		index = i;
		check = ch;
		priority = p;
	}
}
class AnimateCatcher {
	public var index:Int;
	public var plist:Array<AnimateThrower>;
	public var cancel:Void->Bool; // function pointer
	
	public function new( i:Int, vals:Array<AnimateThrower> = null, can:Void->Bool = null ) {
		index = i;
		plist = new Array<AnimateThrower>();
		if ( vals != null )
			for ( val in vals )
				attach( val );
		cancel = can;
	}
	
	public function setCancel( can = null ) {
		cancel = can;
	}
	public function attach( anim:AnimateThrower ):Void {
		var base:Int = anim.priority;
		
		while ( plist.length < base )
			plist.push( null );
			
		if ( plist.length == base ) {
			plist.push( anim );
		} else {
			plist[base] = anim;
		}
	}
	
	public function get():Int {
		if ( cancel == null || !cancel() ) {
			for ( a in plist ) {
				if ( a == null )
					continue;
				if ( a.check() )
					return a.index;
			}
		}
		return -1;
	}
}

class AnimationController {
	public var clist:Map<Int,AnimateCatcher>;
	public var current:Int;
	
	public function new( vals:Array<AnimateCatcher> = null, cur:Int = -1) {
		clist = new Map<Int,AnimateCatcher>();
		if ( vals != null )
			for ( val in vals )
				catcher( val );
		if ( cur != -1 )
			current = cur;
	}
	public function catcher( cat:AnimateCatcher ):Void {
		current = cat.index;
		clist.set(cat.index, cat);
	}
	public function update():Int {
		var cat:AnimateCatcher = clist.get(current);
		var tmp:Int = cat.get();
		if ( tmp != -1 )
			current = tmp;
		return current;
	}
}