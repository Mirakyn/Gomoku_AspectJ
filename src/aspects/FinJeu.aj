package aspects;

import java.util.List;

import core.GridChangeListener;
import core.Player;
import core.model.Grid;
import javafx.scene.paint.Color;
import core.model.Spot;

privileged public aspect FinJeu {

	public List<Spot> Grid.getWinningSpots (){
		return this.winningStones;
	}
	public List<GridChangeListener> Grid.getListeners (){
		return this.listeners;
	}
	public void Spot.ModifyOccupant (Player player){
		this.setOccupant (player);
	}
	
	pointcut notifyGameOver(Grid grid, Player player) : call (void notifyGameOver(Player)) && args (player) && target (grid) && within(Grid);

	/**
	 * At the end of the game clear the notifiers to allow no new moves and set the winning spot in gold color
	 * @param app
	 * @param primaryStage
	 */
	after(Grid grid, Player player) : notifyGameOver(grid, player) {		
		Player winner = new Player ("Winner", Color.GOLD);

		List<Spot> spots = grid.getWinningSpots ();		
		for (Spot p : spots) {
			p.ModifyOccupant (winner);
			grid.notifyStonePlaced(p);
		}
		
		grid.getListeners ().clear();
		
	}
}
