/* Copyright 2016
*
* Diego Islas Ocampo
* Luis Fernando Saavedra
*
* This file is part of Dispatcher.
*
* Dispatcher is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Dispatcher is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Dispatcher. If not, see http://www.gnu.org/licenses/.
*/

class Processor {

    public int id;
    public int current_time;
    public List<Entry> entries;

    public Processor (int id) {
        this.id = id;
        this.current_time = 0;
    }

    // Runs a process in the processor
    public void execute (Process process) {
        int tcc = 0;
        int tvc = 0;

        // Check if processor was sleeping
        if (process.arrival_time > this.current_time || entries.length () == 0) {
            this.current_time = process.arrival_time;
            if (entries.length () != 0) {
                this.entries.append (new Entry (null, tvc, tcc, this.current_time));
            }
        } else {
            tcc = Dispatcher.change_time;
        }

        // Calculate TVC
        if ((process.execution_time % Dispatcher.quantum) == 0) {
            tvc = ((process.execution_time / Dispatcher.quantum)-1) * Dispatcher.change_time;
        } else {
            tvc = ((int)(process.execution_time / Dispatcher.quantum)) * Dispatcher.change_time;
        }

        this.entries.append (new Entry (process, tvc, tcc, this.current_time));

        // Set Current Processor Time given the execution results
        this.current_time += tcc;
        this.current_time += tvc;
        this.current_time += process.blocked_time;
        this.current_time += process.execution_time;
    }
}
