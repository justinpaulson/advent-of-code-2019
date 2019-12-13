package main

import (
	"bufio"
	"fmt"
	"strings"
	"strconv"
  "log"
	"os"
)

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var moons [4][3]int

	scanner := bufio.NewScanner(file)
	j := 0
	for scanner.Scan() {
		string_moon := strings.SplitN(scanner.Text(), ",", -1)
		var int_moon [3]int
		for i, cord := range string_moon {
			conv_cord, _ := strconv.Atoi(cord)
			int_moon[i] = conv_cord
		}
		moons[j] = int_moon
		j++
	}
	zero_velocity := [3]int{0}
	velocities := [4][3]int{zero_velocity}

	fmt.Println(moons)
	fmt.Println(velocities)

	var positions [][4][3]int
	var energies []int

	positions = append(positions, moons)

	// for i := 0; i < 10; i++ {
	// 	moons, velocities = move_moons(moons, velocities)
	// 	positions = append(positions, moons)
	// }

	// fmt.Println(moons)
	// fmt.Println(velocities)
	// fmt.Println(positions)

	position := 0
	for true {
		position++
		if position % 1000000 == 0 {
			fmt.Println(position)
		}
		moons, velocities = move_moons(moons, velocities)
		if !contains(positions, energies, moons, energy(moons)) {
			positions = append(positions, moons)
			energies = append(energies, energy(moons))
		} else {
			fmt.Println("Found match at: ")
			fmt.Println(position)
			break
		}
	}
}

func energy(moons [4][3]int) (total int) {
	total = 0
	for i := 0; i < 4; i++ {
		for j := 0; j < 3; j++ {
			total += abs(moons[i][j])
		}
	}
	return
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func contains(positions [][4][3]int, energies []int, moons [4][3]int, energy int) bool {
	for e, test_energy := range energies {
		if test_energy == energy {
			ret := true
			for i := 0; i < 4; i++ {
				for j := 0; j < 3; j++ {
					if positions[e][i][j] != moons[i][j] {
						ret = false
					}
				}
			}
			if ret { return true }
		}
	}

	return false
}

func move_moons(moons [4][3]int, velocities [4][3]int)([4][3]int, [4][3]int) {
	for i := 0; i < 4; i++ {
		for _, target := range moons {
			for j := 0; j < 3; j++ {
				if moons[i][j] > target[j] {
					velocities[i][j]--
				} else if moons[i][j] < target[j] {
					velocities[i][j]++
				}
			}
		}
	}

	for i := 0; i < 4; i++ {
		for j := 0; j < 3; j++ {
			moons[i][j] += velocities[i][j]
		}
	}

	return moons, velocities
}
