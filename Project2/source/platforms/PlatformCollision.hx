package platforms;

interface PlatformCollision {
	public var overmind:platforms.PlatformGroup;
	public var slot:MoveBase;
	
	public function setSlot( obj:MoveBase ):Void;
	public function collisionCheck( obj:MoveBase ):Void;
}